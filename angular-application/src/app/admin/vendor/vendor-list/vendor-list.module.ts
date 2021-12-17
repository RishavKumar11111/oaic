import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { VendorListRoutingModule } from './vendor-list-routing.module';
import { VendorListComponent } from './vendor-list/vendor-list.component';
import { FormsModule } from '@angular/forms';
import { SharedModule } from 'src/app/shared/shared.module';
import { VendorRegistrationModule } from 'src/app/admin/vendor/vendor-registration-form/vendor-registration.module';


@NgModule({
  declarations: [
    VendorListComponent
  ],
  imports: [
    CommonModule,
    VendorListRoutingModule,
    FormsModule,
    SharedModule,
    VendorRegistrationModule
  ]
})
export class VendorListModule { }
