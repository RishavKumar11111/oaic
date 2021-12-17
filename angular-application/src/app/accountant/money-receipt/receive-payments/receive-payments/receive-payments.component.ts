import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Component, OnInit } from '@angular/core';
import { LayoutService } from 'src/app/services/layout/layout.service';
import { CommonService } from 'src/app/services/common.service';
import { ToastrService } from 'ngx-toastr';

@Component({
  selector: 'app-receive-payments',
  templateUrl: './receive-payments.component.html',
  styleUrls: ['./receive-payments.component.css']
})
export class ReceivePaymentsComponent implements OnInit {
  payment_type: string = 'Advanced'
  advancePaymentDetailsForm: FormGroup;
  CustomerDetails: any = [];
  payments: any = [];
  dist_id: any;
  fin_year: any;
  opening_balance: any;
  totalCredit: any;
  totalDebit: any;
  total_credit: any;
  total_debit: any;
  transactionID: any;
  divisionList: any = []
  implementList: any = []
  invoiceList: any = []
  selectedInvoiceDetails: any = {}
  printPage: boolean = false
  page1: boolean = true
  data: any = {};


  constructor(
    private layoutService: LayoutService,
    private service: CommonService,
    private toastr: ToastrService,
    private fb: FormBuilder
  ) { 
    this.layoutService.setBreadcrumb('receive-payments');
    this.advancePaymentDetailsForm = this.fb.group({
      customerID: ['', [Validators.required]],
      customerInvoiceNo: ['', [Validators.required]],
      division: ['', [Validators.required]],
      productCategory: ['', [Validators.required]],
      paymentReceived: ['',[Validators.required]],
      paymentType: ['DD', [Validators.required]],
      paymentNo: ['', [Validators.required]],
      paymentDate: ['', [Validators.required]],
      sourceBank: ['', [Validators.required]],
      otherBankName: ['', [Validators.required]],
      remark: ['', [Validators.required]]
    })
    this.loadDivisionList();
  }

  ngOnInit(): void {
  this.loadCustomerDetails();
  this.dist_id = this.layoutService.getDistrictID();
  }


  addPayment = async () => {
    try {
      // if(this.advancePaymentDetailsForm.valid) {
        const data = {
          paymentMode: this.payment_type,
          ...this.advancePaymentDetailsForm.value
        }

        const result = await this.service.post(`/accountant/addPaymentReceipt`, data)
        this.toastr.success('Payment added successfully', result.moneyReceiptNo)
        this.advancePaymentDetailsForm.patchValue({
              customerID: '',
              division: '',
              customerInvoiceNo: '',
              productCategory: '',
              paymentReceived: '',
              paymentType: 'DD',
              paymentNo: '',
              paymentDate: '',
              sourceBank: '',
              otherBankName: '',
              remark: ''
        });
        this.implementList = []
        this.payments = []
        this.invoiceList = []
        this.selectedInvoiceDetails = {}
        this.back()
    } catch(e) {
      console.error(e);
      this.toastr.error('Network issue')
    }
  }

  loadCustomerDetails = async () => {
    try {
      this.CustomerDetails = await this.service.get(`/accountant/getDistrictWiseCustomerList`);
    } catch (e) {
      console.error(e);
      this.toastr.error('Error');
    }
  }
  
  loadCustomerLedger = async () => {
    this.fin_year = '2021-22'
    if(this.payment_type == 'PayAgainstInvoice') {
        this.getInvoiceListByCusID()
    }
    let response = await this.service.get('/accountant/getCustomerLedgerByCustomerID?finYear=' + this.fin_year + '&customerID=' + this.advancePaymentDetailsForm.value.customerID );
    this.payments = response;
    let data = response;
    this.opening_balance = 0;
    this.totalCredit = 0;
    this.totalDebit = 0;
    data.filter((e: any) => (e.date = new Date(e.date)));
    data.sort((a: any, b: any) => a.date - b.date);
    for (let i = 0; i < data.length; i++) {
      if (data[i].to == 'DS-' + this.dist_id) {
        data[i].credit = data[i].ammount;
        data[i].debit = 0;
        this.totalCredit += parseFloat(data[i].credit);
      } else if (data[i].from == 'DS-' + this.dist_id) {
        data[i].debit = data[i].ammount;
        data[i].credit = 0;
        this.totalDebit += parseFloat(data[i].debit);
      }
      if (i == 0) {
        data[i].balance =
          parseFloat(data[i].credit) - parseFloat(data[i].debit);
      } else {
        data[i].balance =
          parseFloat(data[i - 1].balance) +
          parseFloat(data[i].credit) -
          parseFloat(data[i].debit);
      }
    }
    this.total_credit = this.totalCredit;
    this.total_debit = this.totalDebit;
  }
  getInvoiceListByCusID = async () => {
    this.invoiceList = await this.service.get('/accountant/getInvoiceListByCusID?finYear=' + this.fin_year + '&customerID=' + this.advancePaymentDetailsForm.value.customerID );
  }
  getCusInvoiceDetailsByInvoiceID = async () => {
    this.selectedInvoiceDetails = await this.service.get('/accountant/getCusInvoiceDetailsByInvoiceID?customerInvoiceNo=' + this.advancePaymentDetailsForm.value.customerInvoiceNo );
  }






  loadDivisionList = async () => {
    try{
          const response = await this.service.get('/accountant/getDivisionList');
          this.divisionList = response;
      } catch(e) {
          console.error(e);
      }
  }
  loadImplementList = async () => {
      try{
          const response = await this.service.get(`/accountant/getImplementList?DivisionID=${this.advancePaymentDetailsForm.value.division}`);
          this.implementList = response.map((e: any) => e.Implement);
      } catch(e) {
          console.error(e);
      }
  }
  proceedPay = () => {

    if (this.advancePaymentDetailsForm.value.sourceBank == 'other_bank') {
      this.advancePaymentDetailsForm.value.sourceBank = this.advancePaymentDetailsForm.value.otherBankName;
    }
    const cusIndex = this.CustomerDetails.findIndex((e: any) => e.CustomerID == this.advancePaymentDetailsForm.value.customerID)
    this.data.date = this.layoutService.getCurrentDate();
    this.data.office = this.layoutService.getUserName();
    this.data.farmer_name = this.CustomerDetails[cusIndex].LegalCustomerName;
    this.data.farmer_id = this.CustomerDetails[cusIndex].CustomerID;
    this.data.full_ammount = this.advancePaymentDetailsForm.value.paymentReceived;
    this.data.permit_no = this.advancePaymentDetailsForm.value.customerInvoiceNo;
    this.data.implement = this.advancePaymentDetailsForm.value.productCategory;
    this.data.payment_mode = this.advancePaymentDetailsForm.value.paymentType;
    this.data.payment_date = this.advancePaymentDetailsForm.value.paymentDate;
    this.data.source_bank = this.advancePaymentDetailsForm.value.sourceBank;
    this.data.acc_name = this.advancePaymentDetailsForm.value;

    this.page1 = false;
    this.printPage = true;
  }
  back = () => {
    this.printPage = false;
    this.page1 = true;
  }








}
