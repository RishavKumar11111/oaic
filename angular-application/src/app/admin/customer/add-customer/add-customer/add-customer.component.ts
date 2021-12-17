import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ToastrService } from 'ngx-toastr';
import { CommonService } from 'src/app/services/common.service';
import { LayoutService } from 'src/app/services/layout/layout.service';

@Component({
  selector: 'app-add-customer',
  templateUrl: './add-customer.component.html',
  styleUrls: ['./add-customer.component.css']
})
export class AddCustomerComponent implements OnInit {

  customerDetailsForm: FormGroup;

  constructor(
    private layoutService: LayoutService,
    private service: CommonService,
    private fb: FormBuilder,
    private toastr: ToastrService
  ) { 

      this.customerDetailsForm = this.fb.group({
          CustomerName: ['', [Validators.required]],
          TradeName: ['', [Validators.required]],
          BussinessConstitution: [''],
          contactNumber: [''],
          CustomerEmailID: [''],
          PANnum: [''],
          GSTNnum: [''],
          ContactPersonList: this.fb.array([]) , 
          PrincipalPlaceList: this.fb.array([]),
          BankAccountList: this.fb.array([]),
          DistrictList: this.fb.array([])

      });
  }

  ngOnInit(): void {
    this.layoutService.setBreadcrumb('Customer / Add Customer');
  }
  step1 = true;
  step2 = false;
  step3 = false;
  step4 = false;
  step5 = false;
  stepper = true;


  step1Complete = false;
  step2Complete = false;
  step3Complete = false;
  step4Complete = false;
  step5Complete = false;

  i: any;
  x: any;
  isCompleteStep1: any;
  completeStep1Bar: any;
  completeStep2Bar: any;
  isCompleteStep2: any;
  completeStep3Bar: any;
  isCompleteStep3: any;
  completeStep4Bar: any;
  isCompleteStep4: any;
  completeStep5Bar: any;
  isCompleteStep5: any;

 

  saveStep1 =  () => {
    if(this.customerDetailsForm.valid){
    this.step1Complete = true;
    this.isCompleteStep1 = 'complete-step';
    this.completeStep1Bar = 'complete-step-bar';
    this.completeStep3Bar = 'active'
    this.goToStep2();
    } else {
      this.toastr.error('Enter required fields.')
    }
  }
  saveStep2 = () => {
    this.step3Complete = true;
    this.isCompleteStep3 = 'complete-step';
    this.completeStep3Bar = 'complete-step-bar';
    this.completeStep4Bar = 'active';
    this.goToStep3();
  }
  saveStep3 = () => {
    this.step4Complete = true;
    this.isCompleteStep4 = 'complete-step';
    this.completeStep4Bar = 'complete-step-bar';
    this.completeStep5Bar = 'active';
    this.goToStep4();
  }


  goToStep1 = () => {
    this.step1 = true;
    this.step2 = false;
    this.step3 = false;
    this.step4 = false;
    this.step5 = false;
}
  goToStep2 = () => {
    this.step1 = false;
    this.step2 = true;
    this.step3 = false;
    this.step4 = false;
    this.step5 = false;
}
  goToStep3 = () => {
    this.step1 = false;
    this.step2 = false;
    this.step3 = true;
    this.step4 = false;
    this.step5 = false;
}
  goToStep4 = () => {
    this.step1 = false;
    this.step2 = false;
    this.step3 = false;
    this.step4 = true;
    this.step5 = false;
}
  goToStep5 = () => {
    this.step1 = false;
    this.step2 = false;
    this.step3 = false;
    this.step4 = false;
    this.step5 = true;
}



AddCustomerDetails = async() => {
  try {
      if(this.customerDetailsForm.valid) {
          await this.service.post(`/admin/addCustomerDetails`, this.customerDetailsForm.value);
          this.toastr.success('Customer Details added successfully');
          this.customerDetailsForm.reset();
          this.goToStep1();

      } else {
        this.toastr.error('Please fill all required fields first');
      }
  } catch (e) {
      this.toastr.error('Sorry. Server problem. Plaese try again.');
      console.error(e);
  }


}






get ContactPersonList() {
  return this.customerDetailsForm.get('ContactPersonList');
}

get principalPlacesList() {
  return this.customerDetailsForm.get('PrincipalPlaceList');
}
get BankAccountList() {
  return this.customerDetailsForm.get('BankAccountList');
}










}
