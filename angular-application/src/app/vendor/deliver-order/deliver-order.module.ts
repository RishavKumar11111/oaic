import { FormsModule } from '@angular/forms';
import { SharedModule } from 'src/app/shared/shared.module';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { DeliverOrderRoutingModule } from './deliver-order-routing.module';
import { DeliverOrderComponent } from './deliver-order.component';
import { NormalCardModule } from 'src/app/shared/ui/normal-card/normal-card.module';
import { TableCardModule } from 'src/app/shared/ui/table-card/table-card.module';


@NgModule({
  declarations: [
    DeliverOrderComponent
  ],
  imports: [
    CommonModule,
    DeliverOrderRoutingModule,
    SharedModule,
    FormsModule,
    NormalCardModule,
    TableCardModule
  ]
})
export class DeliverOrderModule { }
