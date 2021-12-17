import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ToastrService } from 'ngx-toastr';
import { Component, OnInit, ViewChild, ElementRef } from '@angular/core';
import { CommonService } from 'src/app/services/common.service';
import { LayoutService } from 'src/app/services/layout/layout.service';

@Component({
    selector: 'app-partly-money-receive',
    templateUrl: './partly-money-receive.component.html',
    styleUrls: ['./partly-money-receive.component.css']
})
export class PartlyMoneyReceiveComponent implements OnInit {

    @ViewChild("printMR") printMR!: ElementRef;
    receiptDetailsForm: FormGroup
    secondPage: any = false;
    constructor(
        private layoutService: LayoutService,
        private service: CommonService,
        private toastr: ToastrService,
        private fb: FormBuilder
    ) {
        this.layoutService.setBreadcrumb('Money Receipt / Partly Receive');
        this.dist_id = layoutService.getDistrictID();
        this.userid = layoutService.getUserID();
        this.cDate = layoutService.getCurrentDate();
        this.loadFirstRequireedDetails();
        this.receiptDetailsForm = this.fb.group({
            paymentReceived: ['', [Validators.required]],
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

    dist_id: string;
    userid: string;
    showData = false;
    printPage = false;
    enterPaymentNo = false;
    first_card = true;
    cDate: string;
    fin_year = '';
    data: any = {};
    acc_name: string = '';
    loadingData: any;
    allOrders: any = [];
    order: any = {};
    amount_pay_now: any;
    payment_type: any;
    payment_date: any;
    source_bank: any;
    other_bank_name: any;
    payment_no: any;
    remark: any;
    receipt_no: any;
    orderBy: any;
    search_farmer_name: string = '';
    search_permit_no: string = '';

    changeFinancialYear(financialYear: string) {
        this.fin_year = financialYear;
        this.loadOrders();
    }

    loadFirstRequireedDetails = async () => {
        const response = await this.service.get('/accountant/getAccName');
        this.acc_name = response.acc_name;
    }
    loadOrders = async () => {
        this.loadingData = true;
        this.showData = false;
        let myOrders = await this.service.get('/accountant/getPendingPaymentOrders?dist_id=' + this.dist_id + '&fin_year=' + this.fin_year);
        this.allOrders = myOrders;
        this.loadingData = false;
        this.showData = true;
    }
    payDetails = (x: any) => {
        this.order = x;
        this.order.PERMIT_ORDER = x.permit_no
        this.order.FARMER_ID = x.farmer_id
        this.order.VCHFARMERNAME = x.farmer_name
        this.order.VCHFATHERNAME = x.farmer_father_name
        this.order.Dist_Name = x.dist_name
        this.order.block_name = x.block_name
        this.order.vch_GPName = x.gp_name
        this.order.vch_VillageName = x.village_name
        this.order.DT_PERMIT = x.permit_validity
        this.order.DT_P_VALIDITY = x.permit_issue_date
        this.order.Implement = x.implement
        this.order.Make = x.make
        this.order.Model = x.model
        this.order.SUB_AMNT = x.ammount
        this.order.FULL_COST = x.FullCost
        this.amount_pay_now = parseFloat(x.PendingCost)
        this.receiptDetailsForm.get('paymentReceived')?.setValue(this.amount_pay_now)
        this.setEmptyAllFields()
        this.secondPage = true;
    }
    showReceipt = () => {
        // if (this.receiptDetailsForm.valid) 
        // {
            this.amount_pay_now = this.receiptDetailsForm.value.paymentReceived
            this.payment_type = this.receiptDetailsForm.value.paymentType
            this.payment_no = this.receiptDetailsForm.value.paymentNo
            this.payment_date = this.receiptDetailsForm.value.paymentDate
            this.source_bank = this.receiptDetailsForm.value.sourceBank
            this.other_bank_name = this.receiptDetailsForm.value.otherBankName
            this.remark = this.receiptDetailsForm.value.remark

            if (this.amount_pay_now > this.order.PendingCost) {
                this.toastr.error('Pending Cost Exceed. Enter valid cost.')
            } else {
                this.data.date = this.cDate;
                this.data.office = this.order.Dist_Name;
                this.data.farmer_name = this.order.farmer_name;
                this.data.farmer_id = this.order.farmer_id;
                this.data.full_ammount = this.amount_pay_now;
                this.data.permit_no = this.order.permit_no;
                this.data.implement = this.order.implement;
                this.data.payment_mode = this.payment_type;
                this.data.payment_date = this.payment_date;
                this.data.source_bank = this.source_bank;
                this.data.acc_name = this.acc_name;
                this.showData = false;
                this.printPage = true;
                this.first_card = false;
                this.secondPage = true;
                if (this.source_bank == 'other_bank') {
                    this.source_bank = this.other_bank_name;
                }
            }
        // }
        // else 
        // {
        //     // this.showData = false;
        //     // this.first_card = false;
        //     // this.toastr.error('Please fill all required fields first');
        //     // this.setEmptyAllFields()
        //     this.secondPage = true;

        // }
    }
    proceedPay = async () => {
        try {
            this.loadingData = true;
            let paymentDetails = {
                reference_no: this.order.permit_no,
                permit_no: this.order.permit_no,
                payment_type: this.payment_type,
                amount: this.amount_pay_now,
                payby: this.userid,
                farmer_id: this.order.farmer_id,
                dist_id: this.dist_id,
                payment_no: this.payment_no,
                remark: this.remark,
                payment_date: this.payment_date
            }
            let orderDetails = {
                selling_price: this.order.FullCost,
                paid_amount: this.order.paid_amount,
                amount_pay_now: this.amount_pay_now
            }
            let receiptDetails = {
                receipt_no: this.receipt_no,
                office: this.order.dist_name,
                farmer_name: this.order.farmer_name,
                farmer_id: this.order.farmer_id,
                full_ammount: this.amount_pay_now,
                permit_no: this.order.permit_no,
                implement: this.order.implement,
                dist_id: this.dist_id,
                payment_mode: this.payment_type,
                source_bank: this.source_bank,
                payment_no: this.payment_no,
                payment_date: this.payment_date
            }
            const data = { paymentDetails: paymentDetails, orderDetails: orderDetails, receiptDetails: receiptDetails };
            const response = await this.service.post(`/accountant/updateFarmerPendingPayment`, data);
            if (response != '') {
                this.receipt_no = response.receipt_no;
                this.data.receipt_no = response.receipt_no;
                this.loadingData = false;
                this.loadOrders();

                setTimeout(() => {
                    this.printMR.nativeElement.click();
                    this.printPage = false;
                })
                this.setEmptyAllFields();
            } else {
                this.toastr.error('Transaction Failed Try Again!!!!!!');
                this.loadingData = false;
            }
        } catch (e: any) {
            console.log(e);

            this.toastr.error(e.error.error.message, e.statusText)
        }
    }
    setEmptyAllFields = () => {
        this.amount_pay_now = '';
        this.payment_no = '';
        this.source_bank = '';
        this.remark = '';
        this.payment_type = '';
        this.payment_date = '';
    }
    back = () => {
        this.showData = true;
        this.printPage = false;
        this.first_card = true;
    }
    sortedOrderOfColumn = (x: any) => {
        this.orderBy = x;
    }

}
