import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { CustomerListComponent } from './customer-list/customer-list.component';
import { CommonFormModule } from '../common-form/common-form.module';
import { CustomerListRoutingModule } from './customer-list-routing.module';
import { UpdateCustomerComponent } from './update-customer/update-customer.component';
import { ReactiveFormsModule } from '@angular/forms';


@NgModule({
  declarations: [
    CustomerListComponent,
    UpdateCustomerComponent
  ],
  imports: [
    CommonModule,
    CommonFormModule,
    CustomerListRoutingModule,
    ReactiveFormsModule
  ]
})
export class CustomerListModule { }
