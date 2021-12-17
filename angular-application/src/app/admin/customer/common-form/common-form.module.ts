import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { BankDetailsComponent } from './bank-details/bank-details.component';
import { ContactPersonComponent } from './contact-person/contact-person.component';
import { PrincipalPlaceComponent } from './principal-place/principal-place.component';
import { BasicDetailsComponent } from './basic-details/basic-details.component';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';



@NgModule({
  declarations: [
    BankDetailsComponent,
    ContactPersonComponent,
    PrincipalPlaceComponent,
    BasicDetailsComponent
  ],
  imports: [
    CommonModule,
    FormsModule,
    ReactiveFormsModule
  ],
  exports: [
    BankDetailsComponent,
    ContactPersonComponent,
    PrincipalPlaceComponent,
    BasicDetailsComponent
  ]
})
export class CommonFormModule { }
