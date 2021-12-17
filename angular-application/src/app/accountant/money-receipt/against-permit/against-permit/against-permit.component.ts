import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ToastrService } from 'ngx-toastr';
import { Component, OnInit, ViewChild, ElementRef } from '@angular/core';
import { LayoutService } from 'src/app/services/layout/layout.service';
import { CommonService } from 'src/app/services/common.service';
declare const Enumerable: any;
@Component({
    selector: 'app-against-permit',
    templateUrl: './against-permit.component.html',
    styleUrls: ['./against-permit.component.css']
})
export class AgainstPermitComponent implements OnInit {
    printPage: any = false;
    enterPaymentNo: any = false;
    cDate: Date = new Date();
    fin_year: any;
    firstPage: any = false;
    header: any = true;
    secondPage: any = false;
    data: any = {};
    loadingData: any = false;
    response: any;
    acc_name: any;
    dist_id: string;
    allOrders: any = [];
    Enumerable: any;
    element: any;
    search_farmer_name: any;
    search_permit_no: any;
    orderBy: any;
    result: any;
    order: any = {};
    payment_type: any;
    amount_pay_now: any;
    payment_date: any;
    source_bank: any;
    other_bank_name: any;
    payment_no: any;
    remark: any;
    showData: any;
    userid: any;
    receipt_no: any;

    @ViewChild("printMR") printMR!: ElementRef;
    DMDetails: any;
    receiptDetailsForm: FormGroup
    clicked= false;

    constructor(
        private layoutService: LayoutService,
        private service: CommonService,
        private toastr: ToastrService,
        private fb: FormBuilder
    ) {
        this.layoutService.setBreadcrumb('Money Receipt / Against Permit');
        this.dist_id = layoutService.getDistrictID();
        this.receiptDetailsForm = this.fb.group({
            paymentReceived: ['',[Validators.required]],
            paymentType: ['DD', [Validators.required]],
            paymentNo: ['', [Validators.required]],
            paymentDate: ['', [Validators.required]],
            sourceBank: ['', [Validators.required]],
            otherBankName: ['', [Validators.required]],
            remark: ['', [Validators.required]]
          })
    }

    ngOnInit(): void {

    }








    changeFinancialYear(financialYear: string) {
        this.fin_year = financialYear;
        this.loadOrders();
        this.header = true;
    }
    loadAccDetails = async () => {
        const response = await this.service.get('/accountant/getAccName');
        this.acc_name = response.acc_name;
    }
    // this.service.get('http://www.apicol.nic.in/api/FarmerData?farmerId=ANG/75315')
    // .then(response => {
    // console.log(response.data);
    // })
    loadOrders = async () => {
        this.loadingData = true;
        this.firstPage = false;
        const apiCall = this.service.directUrlGet('http://mkuy.apicol.nic.in/api/permit?yr=' + this.fin_year + '&distcd=' + this.dist_id);
        const myOrders = await this.service.get('/accountant/getAvailableOrders?fin_year=' + this.fin_year);
        const apiOrders = await apiCall;

        this.allOrders = Enumerable.From(apiOrders)
            .Except(myOrders, (element: any) => element.permit_no == undefined ? element.PERMIT_ORDER : element.permit_no)
            .ToArray();

        this.allOrders.forEach((item: any) => {
            const validity = item.DT_P_VALIDITY.split("/");
            item.DT_P_VALIDITY = new Date(validity[2], validity[1] - 1, validity[0]);
            const issue_date = item.DT_PERMIT.split("/");
            item.DT_PERMIT = new Date(issue_date[2], issue_date[1] - 1, issue_date[0]);
        })
        // this.allOrders = this.allOrders.filter( (item: any) => Date.parse(item.DT_P_VALIDITY) >= Date.parse(this.cDate));
        this.allOrders.sort((a: any, b: any) => b.DT_PERMIT - a.DT_PERMIT);
        this.loadingData = false;
        this.firstPage = true;

    }
    showDetailes = (x: any) => {
        this.order = x;
    }
    payDetails = async (x: any) => {
        this.order = x;
        this.receiptDetailsForm.patchValue({
            paymentReceived: this.order.FULL_COST
        })
        this.setEmptyAllFields();
        let result = await this.service.get('/accountant/getDMDetails');
        this.DMDetails = result;
        this.payment_type = "DD";
        this.amount_pay_now = parseFloat(x.FULL_COST);
        this.goto2ndPage();
    }
    showReceipt = () => {

        this.amount_pay_now = this.receiptDetailsForm.value.paymentReceived
        this.payment_type = this.receiptDetailsForm.value.paymentType
        this.payment_no = this.receiptDetailsForm.value.paymentNo
        this.payment_date = this.receiptDetailsForm.value.paymentDate
        this.source_bank = this.receiptDetailsForm.value.sourceBank
        this.other_bank_name = this.receiptDetailsForm.value.otherBankName
        this.remark = this.receiptDetailsForm.value.remark


        if(this.amount_pay_now > this.order.FULL_COSTFULL_COST || this.amount_pay_now < 1)
            this.toastr.error('Please enter valid Amount', `Invalid amount`)
        else if (this.payment_date == "")
            this.toastr.error("Please enter all the required fields first");
        else {
            if (this.source_bank == 'other_bank') {
                this.source_bank = this.other_bank_name;
            }
            this.data.date = this.payment_date;// TODO: Letter it will be change to current date. i.e. this.cDate
            this.data.office = this.order.Dist_Name;
            this.data.farmer_name = this.order.VCHFARMERNAME;
            this.data.farmer_id = this.order.FARMER_ID;
            this.data.full_ammount = this.amount_pay_now;
            this.data.permit_no = this.order.PERMIT_ORDER;
            this.data.implement = this.order.Implement;
            this.data.payment_mode = this.payment_type;
            this.data.payment_date = this.payment_date;
            this.data.source_bank = this.source_bank;
            this.data.acc_name = this.acc_name;

            this.secondPage = false;
            this.header = false;
            this.printPage = true;
            this.firstPage = false;
        }

    }
    proceedPay = async () => {
        this.loadingData = true;
        let paymentDetails = {
            reference_no: this.order.PERMIT_ORDER,
            permit_no: this.order.PERMIT_ORDER,
            payment_type: this.payment_type,
            amount: this.amount_pay_now,
            payby: this.userid,
            farmer_id: this.order.FARMER_ID,
            dist_id: this.dist_id,
            payment_no: this.payment_no,
            remark: this.remark,
            payment_date: this.payment_date
        }
        let orderDetails = this.order;
        orderDetails.dist_id = this.dist_id;
        orderDetails.fin_year = this.fin_year;
        orderDetails.paid_amount = this.amount_pay_now;
        let receiptDetails = {
            receipt_no: this.receipt_no,
            office: this.order.Dist_Name,
            farmer_name: this.order.VCHFARMERNAME,
            farmer_id: this.order.FARMER_ID,
            full_ammount: this.amount_pay_now,
            permit_no: this.order.PERMIT_ORDER,
            implement: this.order.Implement,
            dist_id: this.dist_id,
            payment_mode: this.payment_type,
            source_bank: this.source_bank,
            payment_no: this.payment_no,
            payment_date: this.payment_date
        }
        try {
            const data = { paymentDetails: paymentDetails, orderDetails: orderDetails, receiptDetails: receiptDetails };
            
            
            const response = await this.service.post(`/accountant/addPaymentOrderReceipt`, data);
            this.receipt_no = response.receiptNo;
            this.data.receipt_no = response.receiptNo;
            this.loadingData = false;
            console.log(response);
            
            setTimeout(() => {
                this.printMR.nativeElement.click();
                this.printPage = false;
            })


            this.loadOrders();
            this.setEmptyAllFields();
        } catch (e) {
            console.error(e);
            window.alert('Failed to add receive money. Try again.');
            this.loadingData = false;
        }
        finally {
            this.clicked = false;
          }
    }
    setEmptyAllFields = () => {
        this.amount_pay_now = '';
        this.payment_no = '';
        this.source_bank = '';
        this.remark = '';
        this.payment_type = '';
        this.payment_date = '';
        this.other_bank_name = '';
    }
    goto2ndPage = () => {
        this.firstPage = false;
        this.header = false;
        this.secondPage = true;
        this.printPage = false;
    }
    goto1stPage = () => {
        this.header = true;
        this.firstPage = true;
        this.secondPage = false;
        this.printPage = false;
    }
    back = () => {
        this.showData = true;
        this.printPage = false;
        this.firstPage = true;
        this.header = true;
    }
    sortedOrderOfColumn = (x: any) => {
        this.orderBy = x;
    }



}
