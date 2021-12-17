import { ToastrService } from 'ngx-toastr';
import { FormControl } from '@angular/forms';
import { Component, OnInit } from '@angular/core';
import { CommonService } from 'src/app/services/common.service';
import { LayoutService } from 'src/app/services/layout/layout.service';

@Component({
  selector: 'app-initiate',
  templateUrl: './initiate.component.html',
  styleUrls: ['./initiate.component.css']
})
export class InitiateComponent implements OnInit {


  POType: FormControl = new FormControl('NonSubsidy');
  financialYear: FormControl = new FormControl('');
  PONo: FormControl = new FormControl('');
  first_card: boolean = true;
  VendorID: string = '';
  PODetails: any = {};
  accountantDetails: any = {};
  DMDetails: any = {};
  clicked= false;

  constructor(
    private layoutService: LayoutService,
    private service: CommonService,
    private toastr: ToastrService
  ) { 
    this.layoutService.setBreadcrumb('Purchase Order / Initiate');
    this.loadFirstDetails();
  }

  ngOnInit(): void {
  }


  changeFinancialYear(financialYear: string) {
    this.fin_year = financialYear;
  }
  get purchasOrderType(): string {
    return this.POType.value;
  }
  get fin_year(): string {
    return this.financialYear.value;
  }
  set fin_year(value: string) {
    this.financialYear.setValue(value);
  }

  allList: any = [];






  showGIlist = false;
  loadingData = false;


  fin_year_list: any;
  allData: any = [];


  loadFirstDetails = async () => {
    this.accountantDetails = await this.service.get('/accountant/getAccName');
    this.DMDetails = await this.service.get('/accountant/getDMDetails');
    
  }
  indentGenerated = async () => {
          this.addSubsidyIndent();
  }
  addSubsidyIndent = async () => {
      try {
          let response = await this.service.post(`/accountant/addIndent`, this.PODetails.orderList );
          this.PONo.setValue(response.PONo);
                this.toastr.success(`Successfully P.O. Approval send to DM`, `PONo: ${this.PONo.value}`)
                this.showGIlist = false;
                this.first_card = true;
      } catch (e) {
          this.toastr.error('Failed To Initiate P.O. Try Again!!');
          console.error(e);          
      }
      finally {
        this.clicked= false;
      }
  }
  back = () => {
      this.showGIlist = false;
      this.first_card = true;
  }



  showSinglePO = async (x: any) => {
      this.PONo.setValue('');
      this.PODetails.orderList = x.orderList;
      this.PODetails.customerDetails = x.customerDetails;
      this.PODetails.purchasOrderType = this.purchasOrderType;
      const POAmount = this.PODetails.orderList.reduce((a: any, b: any) => a + b.TotalInvoiceValue, 0);

      this.PODetails.vendorDetails = await this.service.get('/accountant/getDelearDetails?VendorID=' + x.vendorID);
      
      this.PODetails.accountantDetails = this.accountantDetails;
      this.PODetails.DMDetails = this.DMDetails;
      this.showGIlist = true;
      this.first_card = false;
      const noOfItems = this.PODetails.orderList.length;
      this.PODetails.orderList.forEach((e: any) => {
            e.POAmount = POAmount;
            e.POType = this.purchasOrderType;
            e.NoOfItemsInPO = noOfItems;
            e.ItemQuantity = e.Quantity;
            e.CustomerID = this.purchasOrderType == 'Subsidy' ? e.permit_no : e.CustomerID;
            e.CustomerOrderRefence = e.orderReference;
      })
  }


  // addNonSubsidyIndent = async () => {
  //     try {
  //         let response = await this.service.post(`/accountant/addNonSubsidyPurchaseOrder`, this.PODetails);
  //         this.PONo.setValue(response);
  //         this.showGIlist = false;
  //         this.first_card = true;
  //     } catch (e) {
  //         this.toastr.error('Failed To Generate Indent. Try Again!!');
  //         console.error(e);
  //     }
  // }

















}
