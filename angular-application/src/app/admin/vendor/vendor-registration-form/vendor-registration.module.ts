import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { VendorRegistrationComponent } from './vendor-registration.component';
import { BasicDetailsComponent } from './basic-details/basic-details.component';
import { ServicesComponent } from './services/services.component';
import { ContactPersonComponent } from './contact-person/contact-person.component';
import { PrincipalPlaceComponent } from './principal-place/principal-place.component';
import { BankDetailsComponent } from './bank-details/bank-details.component';
import { FormsModule } from '@angular/forms';



@NgModule({
  declarations: [
    VendorRegistrationComponent,
    BasicDetailsComponent,
    ServicesComponent,
    ContactPersonComponent,
    PrincipalPlaceComponent,
    BankDetailsComponent
  ],
  imports: [
    CommonModule,
    FormsModule
  ],
  exports: [
    VendorRegistrationComponent
  ]
})
export class VendorRegistrationModule { }
