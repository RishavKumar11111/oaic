import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { ReportRoutingModule } from './report-routing.module';
import { VendorPaymentApprovalComponent } from './vendor-payment-approval/vendor-payment-approval.component';
import { NgxPrintModule } from 'ngx-print';
import { SharedModule } from '../shared/shared.module';


@NgModule({
  declarations: [
    VendorPaymentApprovalComponent
  ],
  imports: [
    CommonModule,
    ReportRoutingModule,
    NgxPrintModule,
    SharedModule
  ],
  exports: [
    VendorPaymentApprovalComponent
  ]
})
export class ReportModule { }
