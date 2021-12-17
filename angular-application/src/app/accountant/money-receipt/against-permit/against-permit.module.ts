import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { NgxPrintModule } from 'ngx-print';

import { AgainstPermitRoutingModule } from './against-permit-routing.module';
import { AgainstPermitComponent } from './against-permit/against-permit.component';
import { FarmerMoneyReceiptModule } from 'src/app/report/farmer-money-receipt/farmer-money-receipt.module';
import { TableCardModule } from 'src/app/shared/ui/table-card/table-card.module';
import { NormalCardModule } from 'src/app/shared/ui/normal-card/normal-card.module';
import { SharedModule } from 'src/app/shared/shared.module';
import { EnterReceiptDetailsModule } from 'src/app/shared/components/enter-receipt-details/enter-receipt-details.module';
import { ViewPermitDetailsModule } from 'src/app/shared/components/view-permit-details/view-permit-details.module';


@NgModule({
  declarations: [
    AgainstPermitComponent
  ],
  imports: [
    CommonModule,
    AgainstPermitRoutingModule,
    SharedModule,
    FormsModule,
    NgxPrintModule,
    FarmerMoneyReceiptModule,
    TableCardModule,
    NormalCardModule,
    EnterReceiptDetailsModule,
    ViewPermitDetailsModule
  ]
})
export class AgainstPermitModule { }
