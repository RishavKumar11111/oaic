import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { ApprovePurchaseOrderRoutingModule } from './approve-purchase-order-routing.module';
import { ApprovePurchaseOrderComponent } from './approve-purchase-order.component';
import { SharedModule } from 'src/app/shared/shared.module';
import { FormsModule } from '@angular/forms';
import { ReportModule } from 'src/app/report/report.module';
import { PoModule } from 'src/app/report/po/po.module';
import { NormalCardModule } from 'src/app/shared/ui/normal-card/normal-card.module';
import { TableCardModule } from 'src/app/shared/ui/table-card/table-card.module';


@NgModule({
  declarations: [
    ApprovePurchaseOrderComponent
  ],
  imports: [
    CommonModule,
    ApprovePurchaseOrderRoutingModule,
    SharedModule,
    FormsModule,
    ReportModule,
    PoModule,
    NormalCardModule,
    TableCardModule
  ]
})
export class ApprovePurchaseOrderModule { 
  constructor() {
    console.log('Approve Purchase Order Module called');
    
  }
}
