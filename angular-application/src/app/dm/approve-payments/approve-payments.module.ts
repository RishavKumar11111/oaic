import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { ApprovePaymentsRoutingModule } from './approve-payments-routing.module';
import { ApprovePaymentsComponent } from './approve-payments.component';
import { SharedModule } from 'src/app/shared/shared.module';
import { FormsModule } from '@angular/forms';
import { ReportModule } from 'src/app/report/report.module';


@NgModule({
  declarations: [
    ApprovePaymentsComponent
  ],
  imports: [
    CommonModule,
    ApprovePaymentsRoutingModule,
    SharedModule,
    FormsModule,
    ReportModule
  ]
})
export class ApprovePaymentsModule { 
  constructor() {
    console.log('Approve Payments Module called');
    
  }
}
