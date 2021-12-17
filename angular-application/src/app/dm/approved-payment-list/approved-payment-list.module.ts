import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { ApprovedPaymentListRoutingModule } from './approved-payment-list-routing.module';
import { ApprovedPaymentListComponent } from './approved-payment-list.component';
import { SharedModule } from 'src/app/shared/shared.module';
import { ReportModule } from 'src/app/report/report.module';


@NgModule({
  declarations: [
    ApprovedPaymentListComponent
  ],
  imports: [
    CommonModule,
    ApprovedPaymentListRoutingModule,
    SharedModule,
    ReportModule
  ]
})
export class ApprovedPaymentListModule { 
  constructor() {
    console.log('Approved Payments List Module called');
    
  }
}
