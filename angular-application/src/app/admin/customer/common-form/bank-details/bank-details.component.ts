import { Component, Input, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';

@Component({
  selector: 'app-bank-details',
  templateUrl: './bank-details.component.html',
  styleUrls: ['./bank-details.component.css']
})
export class BankDetailsComponent implements OnInit {

  @Input() customerDetailsForm: any;

  constructor(
    private fb: FormBuilder
  ) { 
    this.BankDetailsForm = this.fb.group({
      bankAccountNo: ['', [Validators.required]],
      accountType: ['', [Validators.required]],
      bankName: ['', [Validators.required]],
      branchName: ['', [Validators.required]],
      ifscCode: ['', [Validators.required]]
    });

  }

  ngOnInit(): void {
  }
  BankDetailsForm: FormGroup;
  bankAccountsList: any = [];
  bankAccountDocumentsList: any = [];
  selectedBankAccountNumber = '';
  bank: any ={};

  addBankAccount = async () => {
    this.customerDetailsForm.value.BankAccountList.push(this.BankDetailsForm.value);
    this.BankDetailsForm.reset();
  }
  removeBankAccount = (index: number) => {
    this.bankAccountsList.splice(index, 1);
    this.bankAccountDocumentsList.splice(index, 1);
 }
  modifyBankAccount = (index: number, x: any) => {
      this.bankAccountsList.splice(index, 1);
      this.bankAccountDocumentsList.splice(index, 1);
      this.selectedBankAccountNumber = x.AccountNumber;
      this.bank = x;
  }






get BankAccountList() {
  return this.customerDetailsForm.get('BankAccountList').value;
}



}
