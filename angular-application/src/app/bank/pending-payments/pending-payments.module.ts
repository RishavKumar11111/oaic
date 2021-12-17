import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { PendingPaymentsRoutingModule } from './pending-payments-routing.module';
import { PendingPaymentsComponent } from './pending-payments.component';
import { FormsModule } from '@angular/forms';
import { ReportModule } from 'src/app/report/report.module';
import { SharedModule } from 'src/app/shared/shared.module';


@NgModule({
  declarations: [
    PendingPaymentsComponent
  ],
  imports: [
    CommonModule,
    PendingPaymentsRoutingModule,
    FormsModule,
    ReportModule,
    SharedModule
  ]
})
export class PendingPaymentsModule { }
