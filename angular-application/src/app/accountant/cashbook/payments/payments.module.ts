import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { SharedModule } from './../../../shared/shared.module';
import { FormsModule } from '@angular/forms';
import { NgxPrintModule } from 'ngx-print';

import { PaymentsRoutingModule } from './payments-routing.module';
import { CashBookPaymentsComponent } from './cash-book-payments/cash-book-payments.component';


@NgModule({
  declarations: [
    CashBookPaymentsComponent
  ],
  imports: [
    CommonModule,
    SharedModule,
    FormsModule,
    NgxPrintModule,
    PaymentsRoutingModule
  ]
})
export class PaymentsModule { }
