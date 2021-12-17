import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { ApproveVendorRoutingModule } from './approve-vendor-routing.module';
import { ApproveVendorComponent } from './approve-vendor/approve-vendor.component';
import { FormsModule } from '@angular/forms';
import { VendorRegistrationModule } from 'src/app/admin/vendor/vendor-registration-form/vendor-registration.module';


@NgModule({
  declarations: [
    ApproveVendorComponent
  ],
  imports: [
    CommonModule,
    ApproveVendorRoutingModule,
    FormsModule,
    VendorRegistrationModule
  ]
})
export class ApproveVendorModule { }
