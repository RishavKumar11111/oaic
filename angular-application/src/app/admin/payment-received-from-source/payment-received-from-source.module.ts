import { FormsModule } from '@angular/forms';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { PaymentReceivedFromSourceRoutingModule } from './payment-received-from-source-routing.module';
import { PaymentReceiveComponent } from './payment-receive/payment-receive.component';


@NgModule({
  declarations: [
    PaymentReceiveComponent
  ],
  imports: [
    CommonModule,
    PaymentReceivedFromSourceRoutingModule,
    FormsModule
  ]
})
export class PaymentReceivedFromSourceModule { }
