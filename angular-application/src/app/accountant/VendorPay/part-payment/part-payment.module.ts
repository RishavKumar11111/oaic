import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { SharedModule } from './../../../shared/shared.module';
import { FormsModule } from '@angular/forms';
import { NgxPrintModule } from 'ngx-print';

import { PartPaymentRoutingModule } from './part-payment-routing.module';
import { PartPaymentComponent } from './part-payment/part-payment.component';


@NgModule({
  declarations: [
    PartPaymentComponent
  ],
  imports: [
    CommonModule,
    SharedModule,
    FormsModule,
    NgxPrintModule,
    PartPaymentRoutingModule
  ]
})
export class PartPaymentModule { }
