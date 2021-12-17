import { Component, OnInit } from '@angular/core';
import { LayoutService } from 'src/app/services/layout/layout.service';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { CommonService } from 'src/app/services/common.service';
import { ToastrService } from 'ngx-toastr';
import { FormControl, FormGroup } from '@angular/forms';

@Component({
    selector: 'app-pay-to-vendor',
    templateUrl: './pay-to-vendor.component.html',
    styleUrls: ['./pay-to-vendor.component.css']
})
export class PayToVendorComponent implements OnInit {
    dist_id: any;
    fin_year: any;
    dealer: any = {};
    PayDetailes: any = false;
    itemsList: any = false;
    show_invoice_list: any = true;
    paymentInvoice: any = false;
    showPrintIndent: any = false;
    loader: any = false;
    dealer_list: any = [];
    invoice_list: any = [];
    tax_mode: any;
    gst_rate: any;
    invoice_no: any;
    selectedVendorID: any;
    selectedInvoice: any = {};
    payItems: any;
    payList: any;
    dl: any;
    selected_items: any;
    invoice_items: any;
    subTotal: any;
    less_cgst: any;
    less_sgst: any;
    pay_now: any;
    paid_amount: any;
    deduction_amount: any;
    apDesc: any;
    invoice_date: any;
    indent_date: any;
    indent_no: any;
    invoice_amount: any;
    indent_amount: any;
    remark: any;
    approval_id: any = {};

    constructor(
        private layoutService: LayoutService,
        private service: CommonService,
        private http: HttpClient,
        private toastr: ToastrService
    ) {
        this.layoutService.setBreadcrumb('Vendor Pay / Pay To Vendor');
        this.dist_id = layoutService.getDistrictID();
    }

    ngOnInit(): void {
    }


    changeFinancialYear(financialYear: string) {
        this.fin_year = financialYear;
        this.loadInvoiceListByFinYearWise();
        this.loadDealers();

    }

    loadDealers = async () => {
        let response = await this.service.get('/accountant/getAllDistWiseDelear?fin_year=' + this.fin_year + '&dist_id=' + this.dist_id)
        this.dealer_list = response;
    }

    loadInvoiceListByFinYearWise = async () => {
        this.loader = true;
        const response = await this.service.get(`/accountant/getFinYearWiseInvoiceList?fin_year=${this.fin_year}`);
        this.invoice_list = response;
        this.loader = false;
        this.show_invoice_list = true;
        this.paymentInvoice = false;
    }


    loadList = async (x: any) => {
        try {
            this.loader = true;
            this.tax_mode = x.gst_rate == null ? 1 : 2;
            this.gst_rate = x.gst_rate;
            this.invoice_no = x.InvoiceNo;
            this.selectedVendorID = x.VendorID;
            this.selectedInvoice = x;

            const response = await this.service.get('/accountant/getInvoiceItemsForPay?invoice_no=' + this.invoice_no);
            this.itemsList = true;
            this.show_invoice_list = false;
            this.payItems = 0;
            this.payList = response;

            this.payList.forEach((element: any) => {
                const quantity = element.ItemQuantity;
                element.TotalTaxableValue = element.PurchaseTaxableValue * quantity;
                element.TotalCGST = element.PurchaseCGST * quantity;
                element.TotalSGST = element.PurchaseSGST * quantity;
                element.TotalInvoiceValue = element.PurchaseInvoiceValue * quantity;
                const onePercent = element.PurchaseInvoiceValue / (100 + element.TaxRate);
                element.TotalLessCGST = onePercent * quantity;
                element.TotalLessSGST = onePercent * quantity;
            })
            this.loader = false;
            const dealerResponseData = await this.service.get('/accountant/getDelearDetails?VendorID=' + this.selectedVendorID);
            this.dl = dealerResponseData;
        } catch (e) {
            console.error(e);
            window.alert('Unexpected error');
        }
    }

    enterPaymentDetail = async () => {
        this.selected_items = this.payList.filter((x: any) => x.checkbox);
        this.invoice_items = this.selected_items;
        this.subTotal = this.selected_items.reduce((a: any, b: any) => a + b.TotalInvoiceValue, 0);
        this.less_cgst = this.selected_items.reduce((a: any, b: any) => a + b.TotalLessCGST, 0);
        this.less_sgst = this.selected_items.reduce((a: any, b: any) => a + b.TotalLessSGST, 0);

        this.pay_now = this.subTotal - this.less_sgst - this.less_cgst;

        this.paid_amount = 0;
        this.deduction_amount = 0;
        this.apDesc = this.selected_items.map((e: any) => { return { permit_no: e.permit_no, mrr_id: e.mrr_id } });

        this.invoice_date = new Date(this.selectedInvoice.invoice_date);
        this.indent_date = new Date(this.selectedInvoice.ApprovedDate);
        this.indent_no = this.selectedInvoice.indent_no;
        this.invoice_no = this.selectedInvoice.InvoiceNo;
        this.invoice_amount = this.selectedInvoice.invoice_ammount;
        this.indent_amount = this.selectedInvoice.POAmount;
    }

    showDetailesOfPayment = async () => {
        this.pay_now = this.pay_now - this.deduction_amount;
        this.paymentInvoice = true;
        this.itemsList = false;
    }

    sendApproval = async () => {
        try {
            let approval = {
                fin_year: this.fin_year,
                dist_id: this.dist_id,
                dl_id: this.selectedVendorID,
                invoice_no: this.invoice_no,
                indent_no: this.indent_no,
                sub_total: this.subTotal,
                deduction_amount: this.deduction_amount,
                pay_now: this.pay_now,
                remark: this.remark
            }
            let updateInvoice = false;
            if (this.payItems == this.selected_items.length) {
                updateInvoice = true;
            }
            let response = await this.service.post('/accountant/addPaymentApproval', { approval: approval, apDesc: this.apDesc, updateInvoice: updateInvoice, responseType: 'text' });
            this.approval_id = response.approval_id;
            this.toastr.success('Payment Details successfully sent to DM for Approval',`Approval Id: ${this.approval_id}`);
            // printElem('approval');
            //   setTimeout(() => {
            //       this.loadInvoiceListByFinYearWise();
            //   }, 500);
        } catch (e: any) {
            this.toastr.error('Server Problem! Please try again!!');
            console.error(e);
        }
    }


    showIndent = () => {
        console.log('indent View');
        // $scope.showPrintIndent = true; 
    }
    backToInvoice = () => {
        this.itemsList = false;
        this.show_invoice_list = true;
    }
    back = () => {
        this.remark = '';
        this.deduction_amount = 0;
        this.paymentInvoice = false;
        this.itemsList = true;
    }


}
