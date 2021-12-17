import { Component, Input, OnInit } from '@angular/core';
import { CommonService } from 'src/app/services/common.service';

@Component({
  selector: 'app-enter-receipt-details',
  templateUrl: './enter-receipt-details.component.html',
  styleUrls: ['./enter-receipt-details.component.css']
})
export class EnterReceiptDetailsComponent implements OnInit {

  bankList: any = []
  constructor(private commonService: CommonService) { 
    this.loadBankList()
  }


  @Input() receiptDetailsForm: any;


  ngOnInit(): void {
  }

  loadBankList = async () => {
    const response = await this.commonService.get('/getBankList')
    this.bankList = response
    
  }


  changePaymentType = () => {
    if (this.receiptDetailsForm.value.paymentType == 'Cash') {
      this.receiptDetailsForm.value.paymentNo = ''
      this.receiptDetailsForm.value.sourceBank = ''
    }
  }

}
