import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { SharedModule } from './../../../shared/shared.module';
import { FormsModule } from '@angular/forms';
import { NgxPrintModule } from 'ngx-print';

import { RePrintMoneyReceiptRoutingModule } from './re-print-money-receipt-routing.module';
import { RePrintMrComponent } from './re-print-mr/re-print-mr.component';
import { FarmerMoneyReceiptModule } from 'src/app/report/farmer-money-receipt/farmer-money-receipt.module';


@NgModule({
  declarations: [
    RePrintMrComponent
  ],
  imports: [
    CommonModule,
    RePrintMoneyReceiptRoutingModule,
    FormsModule,
    SharedModule,
    NgxPrintModule,
    FarmerMoneyReceiptModule
  ]
})
export class RePrintMoneyReceiptModule { }
