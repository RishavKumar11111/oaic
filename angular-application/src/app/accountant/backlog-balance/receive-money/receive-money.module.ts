import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { SharedModule } from './../../../shared/shared.module';
import { FormsModule } from '@angular/forms';
import { NgxPrintModule } from 'ngx-print';


import { ReceiveMoneyRoutingModule } from './receive-money-routing.module';
import { ReceiveBacklogMoneyComponent } from './receive-backlog-money/receive-backlog-money.component';


@NgModule({
  declarations: [
    ReceiveBacklogMoneyComponent
  ],
  imports: [
    CommonModule,
    ReceiveMoneyRoutingModule,
    SharedModule,
    FormsModule,
    NgxPrintModule
    
  ]
})
export class ReceiveMoneyModule { }
