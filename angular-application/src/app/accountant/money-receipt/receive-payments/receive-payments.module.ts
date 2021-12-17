import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { ReceivePaymentsRoutingModule } from './receive-payments-routing.module';
import { ReceivePaymentsComponent } from './receive-payments/receive-payments.component';
import { FormsModule, ReactiveFormsModule} from '@angular/forms';
import { NgxPrintModule } from 'ngx-print';
import { FarmerMoneyReceiptModule } from 'src/app/report/farmer-money-receipt/farmer-money-receipt.module';
import { NormalCardModule } from 'src/app/shared/ui/normal-card/normal-card.module';
import { TableCardModule } from 'src/app/shared/ui/table-card/table-card.module';
import { EnterReceiptDetailsModule } from 'src/app/shared/components/enter-receipt-details/enter-receipt-details.module';


@NgModule({
  declarations: [
    ReceivePaymentsComponent
  ],
  imports: [
    CommonModule,
    ReceivePaymentsRoutingModule,
    FormsModule,
    ReactiveFormsModule,
    NgxPrintModule,
    FarmerMoneyReceiptModule,
    TableCardModule,
    NormalCardModule,
    EnterReceiptDetailsModule
  ]
})
export class ReceivePaymentsModule { }
