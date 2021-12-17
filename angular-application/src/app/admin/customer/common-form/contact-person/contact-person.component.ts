import { Component, Input, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ToastrService } from 'ngx-toastr';

@Component({
  selector: 'app-contact-person',
  templateUrl: './contact-person.component.html',
  styleUrls: ['./contact-person.component.css']
})
export class ContactPersonComponent implements OnInit {

  contactPersonForm: FormGroup;
  @Input() customerDetailsForm: any;

  constructor(private fb: FormBuilder, private toastr: ToastrService) { 
    
  this.contactPersonForm = this.fb.group({
    AuthorisedName: ['', [Validators.required]],
    AuthorisedMobileNo: ['', [Validators.required]],
    AuthorisedEmailID: ['', [Validators.required]],
    Designation: ['', [Validators.required]],

  });
  }

  ngOnInit(): void {
  }




  
  addAuthorisedSignatory = () => {
    if(this.contactPersonForm.valid) {
      this.customerDetailsForm.value.ContactPersonList.push(this.contactPersonForm.value);
      this.contactPersonForm.reset();
    } else {
      this.toastr.error('Please enter all required Fields');
    }
}
removeAuthorisedSignatory = (index: number) => {
    this.ContactPersonList.value.splice(index, 1);
}
modifyAuthorisedSignatory = (index: number, x: any) => {
    this.ContactPersonList.value.splice(index, 1);
    this.contactPersonForm.patchValue({
      AuthorisedName: x.AuthorisedName,
      AuthorisedMobileNo: x.AuthorisedMobileNo,
      AuthorisedEmailID: x.AuthorisedEmailID,
      Designation: x.Designation,
    })
}




get ContactPersonList() {
  return this.customerDetailsForm.get('ContactPersonList');
}






}
