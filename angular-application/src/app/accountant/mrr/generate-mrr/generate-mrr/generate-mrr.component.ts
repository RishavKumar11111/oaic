import { Component, OnInit, ViewChild, ElementRef } from '@angular/core';
import { ToastrService } from 'ngx-toastr';
import { CommonService } from 'src/app/services/common.service';
import { LayoutService } from 'src/app/services/layout/layout.service';

@Component({
  selector: 'app-generate-mrr',
  templateUrl: './generate-mrr.component.html',
  styleUrls: ['./generate-mrr.component.css']
})
export class GenerateMrrComponent implements OnInit {

  mrr: any = {}
  selectedItem: any = {}
  @ViewChild("printMRR") printMRR!: ElementRef;
    clicked= false;

  constructor(
    private layoutService: LayoutService,
    private service: CommonService,
    private toastr: ToastrService
  ) { 
    this.layoutService.setBreadcrumb('Material Receipt Report / Generate MRR ( Receive Items )');
    this.dist_id = layoutService.getDistrictID();
    this.loadAlldetailsFirst();
  }
  ngOnInit(): void {
  }





  changeFinancialYear(financialYear: string) {
    this.fin_year = financialYear;
    this.loadAllInvoiceList();
    this.loadDelears();
  }

    showTable = false;
    printPage = false;
    loadingData = false;
    showInvoiceTable = false;
    first_page = true;
    fin_year: string = '';
    all_invoices: any = [];
    AccountantDetails: any;
    search_invoice_no: string = '';
    search_farmer_name: string = '';
    search_permit_no: string = '';
    dealer: any = '';
    DMDetails: any;
    all_dealers: any = [];
    selectedPONo: any;
    selectedInvoiceNo: any;
    selectedVendorID: any;
    invoice: any;
    tax_mode: any;
    gst_rate: any;
    noOfInvoice: any;
    dealer_name: any;
    allData: any;
    noOfMRRGenerated: any;
    printData: any;
    vendorDetails: any;
    totalPriceInTable: any;
    dist_id: string;
    loadAllInvoiceList = async () => {
        const response = await this.service.get('/accountant/getAllInvoiceList?fin_year=' + this.fin_year);
                this.all_invoices = response;
                this.all_invoices.forEach((e: any) => {
                    if(!e.PONo) {
                        e.PONo = e.indent_no;
                    }
                })
                this.showInvoiceTable = true;
                this.first_page = true;
                this.loadingData = false;
    }
    loadAlldetailsFirst = async () => {
      this.AccountantDetails = await this.service.get('/accountant/getAccName');
      this.DMDetails = await this.service.get('/accountant/getDMDetails');
    }
    loadDelears = async () => {
      this.all_dealers = await this.service.get('/accountant/getAllDistWiseDelear');
    }
    loadTable = async (x: any) => {
        this.selectedPONo = x.PONo;
        this.selectedInvoiceNo = x.InvoiceNo;
        this.selectedVendorID = x.VendorID;
        this.loadingData = true;
        this.invoice = x;
        this.tax_mode = x.gst_rate == null ? 1 : 2;
        this.gst_rate = x.gst_rate;
        const response = await this.service.get('/accountant/getOrdersForReceive?invoiceNo=' + x.InvoiceNo);
                this.noOfInvoice = 0;
                response.forEach((element: any) => {
                    console.log(element.IsReceived);
                    
                    if (element.IsReceived) {
                        element.isReceivedClass = { 'background-color': 'aquamarine' };
                    } else {
                        this.noOfInvoice++;
                    }
                });
                this.loadingData = false;
                this.showInvoiceTable = false;
                this.showTable = true;
                this.first_page = false;
                this.dealer_name = x.LegalBussinessName;
                this.allData = response;
                this.noOfMRRGenerated = 0;
    }
    proceedPay = (x: any) => {
        this.selectedItem = x;
        this.selectedItem.ReceivedQuantity = x.SupplyQuantity;
    }
    receiveItem = () => {
        if((+this.selectedItem.ReceivedQuantity <= +this.selectedItem.SupplyQuantity) && (this.selectedItem.ReceivedQuantity > 0)) {
            const index = this.allData.findIndex((e: any) => e.OrderReferenceNo == this.selectedItem.OrderReferenceNo)
            this.allData[index].IsReceived = true;
            this.allData[index].isReceivedClass = { 'background-color': 'aquamarine' };
            this.allData[index].ReceivedQuantity = this.selectedItem.ReceivedQuantity;
            this.noOfMRRGenerated++;
        } else {
            this.toastr.error(`Enter Quantity within ${this.selectedItem.SupplyQuantity}`, `Quantity Exceed`)
        }
    }
    previewMrr = async() => {
        this.printData = this.allData.filter((e: any) => e.IsReceived);

        if(this.printData.length > 0) {
            this.vendorDetails = await this.service.get('/accountant/getDelearDetails?VendorID=' + this.selectedVendorID);
            this.invoice.bill_date = new Date(this.invoice.InvoiceDate);
            this.invoice.rr_way_bill_date = new Date(this.invoice.WayBillDate);
            this.totalPriceInTable = this.printData.reduce((a: any, b: any) => a + +b.TotalPurchaseInvoiceValue, 0);
            this.totalPriceInTable = this.totalPriceInTable - this.selectedItem.Discount
            this.showTable = false;
            this.printPage = true;
        } else {
            this.toastr.error('Minimum 1 item require to Generate MRR');
        }
        
    }
    generateMRR = async () => {
        try {
            const MRRData = this.printData.map((e: any) => {
                return {
                    POType: e.POType,
                    OrderReferenceNo: e.OrderReferenceNo,
                    ItemQuantity: e.ItemQuantity,
                    MRRAmount: this.totalPriceInTable,
                    PONo: this.selectedPONo,
                    InvoiceNo: this.selectedInvoiceNo,
                    VendorID: this.selectedVendorID,
                    NoOfItemReceived: this.printData.length,
                    ReceivedQuantity: e.ReceivedQuantity
                };
            })
            let dealer_bill = {
                amount: this.totalPriceInTable,
                dist_id: this.dist_id,
                dl_id: this.selectedVendorID
            }
            let updateInvoice = false;
            if (this.noOfInvoice == this.noOfMRRGenerated) {
                updateInvoice = true;
            }
            const data = { MRRData: MRRData, updateInvoice: updateInvoice, dealer_bill: dealer_bill };
            const response = await this.service.post(`/accountant/addMRR`, data);
            this.mrr.MRRNo = response.MRRNo;
            setTimeout(() => {
              this.printMRR.nativeElement.click();
              this.showTable = false;
              this.printPage = false;
              this.loadAllInvoiceList();
            })
        }
        catch(e) {
            this.toastr.error('Failed to generate MRR. Please try again.');
            console.error(e);
        }
        
        finally {
            this.clicked= false;
          }

    }
    back = () => {
        this.showTable = false;
        this.showInvoiceTable = true;
        this.first_page = true;
    }
    back2 = () => {
        this.printPage = false;
        this.showTable = true;
    }








}
