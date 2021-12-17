import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { SharedModule } from './../../../shared/shared.module';
import { FormsModule } from '@angular/forms';
import { NgxPrintModule } from 'ngx-print';

import { PayToVendorRoutingModule } from './pay-to-vendor-routing.module';
import { PayToVendorComponent } from './pay-to-vendor/pay-to-vendor.component';
import { ReportModule } from 'src/app/report/report.module';


@NgModule({
  declarations: [
    PayToVendorComponent
  ],
  imports: [
    CommonModule,
    SharedModule,
    FormsModule,
    NgxPrintModule,
    PayToVendorRoutingModule,
    ReportModule
  ]
})
export class PayToVendorModule { }
