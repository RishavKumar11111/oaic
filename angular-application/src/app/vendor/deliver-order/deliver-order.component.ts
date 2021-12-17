import { ToastrService } from 'ngx-toastr';
import { Component, OnInit } from '@angular/core';
import { LayoutService } from 'src/app/services/layout/layout.service';
import { CommonService } from 'src/app/services/common.service';

declare const document: any;
@Component({
    selector: 'app-deliver-order',
    templateUrl: './deliver-order.component.html',
    styleUrls: ['./deliver-order.component.css']
})
export class DeliverOrderComponent implements OnInit {

    discount: number = 0
    finalInvoiceAmount: number = 0
    clicked= false;
    constructor(
        private layoutService: LayoutService,
        private service: CommonService,
        private toastr: ToastrService
    ) {
        this.layoutService.setBreadcrumb('Deliver Order');
    }

    ngOnInit(): void {
    }

    dl_id = `document.querySelector('meta[name="dl_id"]').getAttribute('content')`;
    c_date = new Date();
    fin_year = '';
    first_box = true;
    show_indent_list = false;
    show_order_list = false;
    show_print_page = false;
    show_extra_fields = false;
    loader = false;
    generateInvoiceStatus = true;
    itemsForDeliver: any = [];
    my_bill_ammout: any = 0;
    dmDetails: any = {};
    order: any = {};


    invoice_no: any;
    selected_indent: any;
    DistrictID: any;
    rr_way_bill_no: any;
    thiswagon_truck_no: any;
    rr_way_bill_date: any;
    invoice_date: any;

    allData: any = [];
    hideRows: any = [];
    noOfIndent: any;
    noOfInvoice: any;
    deliver_quantity: any;
    engine_no: any;
    chassic_no: any;
    check_invoice_no: any;
    permit_nos: any;
    invoiceItems: any = [];
    wagon_truck_no: any;

    searchPONo: string = '';
    searchFarmerName: string = '';
    searchPermitNo: string = '';
    dist: any = '';
    districts: any = [];
    indent_list: any = [];
    totalmode2: any;
    matchByFarmerName: any;
    matchByPermitNo: any;
    rowIndex: any;


    changeFinancialYear(financialYear: string) {
        this.fin_year = financialYear;
        this.loadAllIndents();
        this.loadDists();
    }

    loadDists = async () => {
        this.show_indent_list = false;
        this.show_order_list = false;
        this.show_print_page = false;
        this.show_extra_fields = false;
        this.districts = await this.service.get(`/dl/getDealerDists?fin_year=${this.fin_year}`);
    }
    loadAllIndents = async () => {

        this.show_indent_list = false;
        this.loader = true;
        this.indent_list = await this.service.get(`/dl/getAllDistIndent?fin_year=${this.fin_year}`);
        this.show_indent_list = true;
        this.loader = false;
    }
    fillExtraFields = () => {
        this.show_order_list = false;
        this.show_extra_fields = true;
    }
    checkInvoiceNo = async () => {
        this.check_invoice_no = await this.service.get(`/dl/checkInvoiceNoIsExist?invoice_no=${this.invoice_no}`);
    }
    back1 = () => {
        this.show_order_list = false;
        this.show_indent_list = true;
        this.first_box = true;
        this.itemsForDeliver = [];
    }
    back2 = () => {
        this.show_extra_fields = false;
        this.show_order_list = true;
    }
    back3 = () => {
        this.show_print_page = false;
        this.show_extra_fields = true;
    }




    POAmount: any;
    POType: any;
    selectedPO: any = {};
    invoice_file: any;
    loadList = async (x: any) => {
        this.selectedPO = x;
        this.DistrictID = x.DistrictID;
        this.show_indent_list = false;
        this.loader = true;
        this.my_bill_ammout = 0;
        this.selected_indent = x.PONo;
        this.POAmount = x.POAmount;
        this.POType = x.POType;
        this.dmDetails = await this.service.get('/dl/getDMDetails?dist_id=' + this.DistrictID);
        const response = await this.service.get('/dl/getIndentOrdersForDeliver?PONo=' + x.PONo)
        
        this.show_order_list = true;
        this.loader = false;
        this.first_box = false;
        this.itemsForDeliver = [];
        this.invoiceItems = []
        this.noOfIndent = 0;
        this.noOfInvoice = 0;
        this.allData = response.filter((item: any, index: number) => {
            item.SupplyQuantity = item.DeliveredQuantity
            if (item.IsDelivered) {
                item.isDelivered = true;
                item.isDeliveredClass = { 'background-color': 'aquamarine' };
            } else {
                this.noOfIndent++;
            }
            return item;
        });
    }
    deliveryDetails = (x: any) => {
        this.order = x
        this.deliver_quantity = this.order.PendingQuantity
    }
    addDeliverItem = () => {
        const isEngChasNoRequired = this.order.Implement == 'Tractor' || this.order.Implement == 'Power tiller' ? true : false;
        const isEntered = isEngChasNoRequired ? (this.engine_no && this.chassic_no) : true;
        if (isEntered) {

            if((+this.deliver_quantity <= +this.order.PendingQuantity) && (+this.deliver_quantity > 0)) {

                this.order.PendingQuantity = this.order.PendingQuantity - this.deliver_quantity
    
                if( this.deliver_quantity == this.order.ItemQuantity ) {

                    this.pushItem();

                } else {
                        this.order.PackageSize ? this.calculatePackageQuantity() : this.calculateItemWiseTax()
                }
            } else {
                this.toastr.error(`Enter Quantity within ${this.order.PendingQuantity}`, `Quantity Exceed`)
            }

        } else {
            this.toastr.error('Please enter valid Engine No. & Chassic No.');
        }
    }

    calculatePackageQuantity = () => {
        const totalQuantity = this.deliver_quantity;
        const packateSize = this.order.PackageSize;
        const unitOfMeasurement = this.order.UnitOfMeasurement;
        const packateUnitOfMeasurement = this.order.PackageUnitOfMeasurement;
        let finalUnit = 1;

        if(unitOfMeasurement == packateUnitOfMeasurement) {
            finalUnit = 1;
        } else if(unitOfMeasurement == 'Kilograms' && packateUnitOfMeasurement == 'Gram') {
            finalUnit = 1000;
        } else if(unitOfMeasurement == 'Metric Ton' && packateUnitOfMeasurement == 'Gram') {
            finalUnit = 1000000;
        } else if(unitOfMeasurement == 'Metric Ton' && packateUnitOfMeasurement == 'Kilograms') {
            finalUnit = 1000;
        } else if(unitOfMeasurement == 'Tonnes' && packateUnitOfMeasurement == 'Gram') {
            finalUnit = 1000000;
        } else if(unitOfMeasurement == 'Tonnes' && packateUnitOfMeasurement == 'Kilograms') {
            finalUnit = 1000;
        } else if(unitOfMeasurement == 'Liter' && packateUnitOfMeasurement == 'Mililiter') {
            finalUnit = 1000;
        } else {
            this.toastr.error('Selected unit not Mapped');
        }

        const quantity = ( totalQuantity * finalUnit ) / packateSize;
        const isDividable = ( totalQuantity * finalUnit ) % packateSize;
        if(isDividable == 0) {
            this.order.SupplyPackageQuantity = quantity;
            this.order.TotalPurchaseTaxableValue = (this.order.PurchaseTaxableValue * quantity).toFixed(2);
            this.order.TotalPurchaseInvoiceValue = (this.order.PurchaseInvoiceValue * quantity).toFixed(2);
            this.order.TotalPurchaseCGST = (this.order.PurchaseCGST * quantity).toFixed(2);
            this.order.TotalPurchaseSGST = (this.order.PurchaseSGST * quantity).toFixed(2);
            this.order.TotalPurchaseIGST = (this.order.PurchaseIGST * quantity).toFixed(2);

            this.pushItem();
        } else {
            this.toastr.error('Sorry, Please enter valid Quantity');
            this.deliver_quantity = this.order.ItemQuantity;
        }
    }

    calculateItemWiseTax = () => {
        const quantity = this.deliver_quantity
        this.order.SupplyPackageQuantity = 0;
        this.order.TotalPurchaseTaxableValue = (this.order.PurchaseTaxableValue * quantity).toFixed(2);
        this.order.TotalPurchaseInvoiceValue = (this.order.PurchaseInvoiceValue * quantity).toFixed(2);
        this.order.TotalPurchaseCGST = (this.order.PurchaseCGST * quantity).toFixed(2);
        this.order.TotalPurchaseSGST = (this.order.PurchaseSGST * quantity).toFixed(2);
        this.order.TotalPurchaseIGST = (this.order.PurchaseIGST * quantity).toFixed(2);

        this.pushItem();
    }
    pushItem = () => {
                this.finalInvoiceAmount = this.my_bill_ammout = this.my_bill_ammout + +this.order.TotalPurchaseInvoiceValue;
                const index = this.allData.findIndex((e: any) => e.OrderReferenceNo == this.order.OrderReferenceNo);
                this.allData[index].isDelivered = true;
                this.allData[index].isDeliveredClass = { 'background-color': 'aquamarine' };
                this.allData[index].SupplyQuantity = this.deliver_quantity;
                this.itemsForDeliver.push({
                    PONo: this.order.PONo,
                    OrderReferenceNo: this.order.OrderReferenceNo,
                    EngineNumber: this.engine_no,
                    ChassicNumber: this.chassic_no,
                    TotalPurchaseTaxableValue: this.order.TotalPurchaseTaxableValue,
                    TotalPurchaseInvoiceValue: this.order.TotalPurchaseInvoiceValue,
                    TotalPurchaseCGST: this.order.TotalPurchaseCGST,
                    TotalPurchaseSGST: this.order.TotalPurchaseSGST,
                    TotalPurchaseIGST: this.order.TotalPurchaseIGST,
                    SupplyQuantity: this.deliver_quantity,
                    SupplyPackageQuantity: this.order.SupplyPackageQuantity
                });
                this.order.EngineNumber = this.engine_no;
                this.order.ChassicNumber = this.chassic_no;
                this.invoiceItems.push(this.order);
                this.engine_no = '';
                this.chassic_no = '';
                this.noOfInvoice++;
    }
    calculateFinalInvoiceAmount = () => {
        if(this.my_bill_ammout > this.discount) {
                this.finalInvoiceAmount = this.my_bill_ammout - this.discount
        } else {
            this.toastr.error(`Discount must be within ${this.my_bill_ammout}`, `Discount exceed`)
            this.discount = 0
        }
    }













    invoicePreview = async () => {
        this.invoice_file = document.querySelector('#invoice').files[0]
        const invoice_file = this.invoice_file;
        if (invoice_file != undefined) {
            if (invoice_file.type == 'application/pdf') {
                if (!this.check_invoice_no) {

                    this.show_extra_fields = false;
                    this.show_print_page = true;
                } else {
                    window.alert('Enter valid invoice no.');
                }
            } else {
                window.alert('Choose PDF File !!');
            }
        } else {
            window.alert('Upload Invoice');
        }
    }
    generateInvoice = async () => {
        try {
            let invoice = {
                InvoiceNo: this.invoice_no,
                PONo: this.selected_indent,
                DistrictID: this.DistrictID,
                WayBillNo: this.rr_way_bill_no,
                WayBillDate: this.rr_way_bill_date,
                InvoiceDate: this.invoice_date,
                NoOfOrderInPO: this.selectedPO.NoOfItemsInPO,
                NoOfOrderDeliver: this.itemsForDeliver.length,
                InvoiceAmount: this.finalInvoiceAmount,
                Discount: this.discount,
                POType: this.POType
            }
            let all_data = { invoice: invoice, items_for_deliver: this.itemsForDeliver };
            
            var data = new FormData();
            data.append('invoice', this.invoice_file);
            data.append("Name1", JSON.stringify(all_data));
            const response = await this.service.post(`/dl/addInvoice`, data);
            if (response == "true" || response == true) {
                this.toastr.success('Invoice generated and successfully submitted to OAIC.');
                this.loadAllIndents();
                this.back1();
                this.invoice_no = ''
                this.rr_way_bill_no = ''
                this.rr_way_bill_date = ''
                this.invoice_date = ''

            } else {
                this.toastr.error('Failed to generate invoice. Try again.');
            }
        } catch (e) {
            console.error(e);
            this.toastr.error('Network Problem');
        }
        finally {
            this.clicked= false;
          }

    }


}
