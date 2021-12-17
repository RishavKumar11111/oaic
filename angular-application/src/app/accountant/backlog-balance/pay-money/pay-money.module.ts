import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { SharedModule } from './../../../shared/shared.module';
import { FormsModule } from '@angular/forms';
import { NgxPrintModule } from 'ngx-print';

import { PayMoneyRoutingModule } from './pay-money-routing.module';
import { PayBacklogMoneyComponent } from './pay-backlog-money/pay-backlog-money.component';


@NgModule({
  declarations: [
    PayBacklogMoneyComponent
  ],
  imports: [
    CommonModule,
    PayMoneyRoutingModule,
    SharedModule,
    FormsModule,
    NgxPrintModule
  ]
})
export class PayMoneyModule { }
