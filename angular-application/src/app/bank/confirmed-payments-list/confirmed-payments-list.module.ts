import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { ConfirmedPaymentsListRoutingModule } from './confirmed-payments-list-routing.module';
import { ConfirmedPaymentsListComponent } from './confirmed-payments-list.component';
import { FormsModule } from '@angular/forms';
import { ReportModule } from 'src/app/report/report.module';
import { SharedModule } from 'src/app/shared/shared.module';


@NgModule({
  declarations: [
    ConfirmedPaymentsListComponent
  ],
  imports: [
    CommonModule,
    ConfirmedPaymentsListRoutingModule,
    FormsModule,
    ReportModule,
    SharedModule
  ]
})
export class ConfirmedPaymentsListModule { }
