import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ToastrService } from 'ngx-toastr';
import { CommonService } from 'src/app/services/common.service';

@Component({
  selector: 'app-update-customer',
  templateUrl: './update-customer.component.html',
  styleUrls: ['./update-customer.component.css']
})
export class UpdateCustomerComponent implements OnInit {

  @Input() selectedCustomerID: any;
  @Output() eventAfterUpdateDone: EventEmitter<any>= new EventEmitter(); 
  customerDetailsForm: FormGroup;

  constructor(
    private service: CommonService, 
    private toastr: ToastrService,
    private fb: FormBuilder,
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
    this.loadCustomerDetails();
  }

  loadCustomerDetails = async () => {
    try {
      const result = await this.service.get(`/admin/getCustomerDetails?CustomerID=${this.selectedCustomerID}`);
      this.customerDetailsForm.patchValue({
            CustomerName: result.LegalCustomerName,
            TradeName: result.TradeName,
            BussinessConstitution: result.BussinessConstitution,
            contactNumber: result.ContactNumber,
            CustomerEmailID: result.EmailID,
            PANnum: result.PAN,
            GSTNnum: result.GSTN
      });

      result.ContactPersonList.forEach((e: any) => {
          this.ContactPersonList?.value.push(e);
      })
      result.PrincipalPlaceList.forEach((e: any) => {
          this.principalPlacesList?.value.push(e);
      })
      result.BankAccountList.forEach((e: any) => {
          this.BankAccountList?.value.push(e);
      })
      result.DistrictList.forEach((e: any) => {
          this.DistrictList?.value.push(e);
      })


    } catch(e) {
      console.error(e);
      this.toastr.error('Network Problem, Try Again.');
      
    }
    
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



FinalUpdateCustomerDetails = async() => {
  try {
      if(this.customerDetailsForm.valid) {
          await this.service.post(`/admin/updateCustomerDetails/${this.selectedCustomerID}`, this.customerDetailsForm.value );
          this.toastr.success('Customer Details updated successfully');
          
          this.eventAfterUpdateDone.emit();


      } else {
        this.toastr.error('Required fields cannot blank. please fill required fields.');
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
get DistrictList() {
  return this.customerDetailsForm.get('DistrictList');
}









}
