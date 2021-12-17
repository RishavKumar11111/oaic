import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { AddCustomerRoutingModule } from './add-customer-routing.module';
import { AddCustomerComponent } from './add-customer/add-customer.component';

import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { CommonFormModule } from '../common-form/common-form.module';

@NgModule({
  declarations: [
    AddCustomerComponent
  ],
  imports: [
    CommonModule,
    AddCustomerRoutingModule,
    CommonFormModule,
    FormsModule,
    ReactiveFormsModule
  ]
})
export class AddCustomerModule { }
