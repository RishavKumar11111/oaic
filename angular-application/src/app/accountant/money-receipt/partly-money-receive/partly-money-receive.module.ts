import { FormsModule } from '@angular/forms';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { PartlyMoneyReceiveRoutingModule } from './partly-money-receive-routing.module';
import { PartlyMoneyReceiveComponent } from './partly-money-receive/partly-money-receive.component';
import { SharedModule } from 'src/app/shared/shared.module';
import { NgxPrintModule } from 'ngx-print';
import { FarmerMoneyReceiptModule } from 'src/app/report/farmer-money-receipt/farmer-money-receipt.module';
import { ViewPermitDetailsModule } from 'src/app/shared/components/view-permit-details/view-permit-details.module';
import { EnterReceiptDetailsModule } from 'src/app/shared/components/enter-receipt-details/enter-receipt-details.module';


@NgModule({
  declarations: [
    PartlyMoneyReceiveComponent
  ],
  imports: [
    CommonModule,
    PartlyMoneyReceiveRoutingModule,
    FormsModule,
    SharedModule,
    NgxPrintModule,
    FarmerMoneyReceiptModule,
    ViewPermitDetailsModule,
    EnterReceiptDetailsModule
  ]
})
export class PartlyMoneyReceiveModule { }
