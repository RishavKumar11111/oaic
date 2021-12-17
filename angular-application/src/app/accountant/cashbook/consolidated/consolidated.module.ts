import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { SharedModule } from './../../../shared/shared.module';
import { FormsModule } from '@angular/forms';
import { NgxPrintModule } from 'ngx-print';

import { ConsolidatedRoutingModule } from './consolidated-routing.module';
import { CashBookConsolidatedComponent } from './cash-book-consolidated/cash-book-consolidated.component';


@NgModule({
  declarations: [
    CashBookConsolidatedComponent
  ],
  imports: [
    CommonModule,
    SharedModule,
    FormsModule,
    NgxPrintModule,
    ConsolidatedRoutingModule
  ]
})
export class ConsolidatedModule { }
