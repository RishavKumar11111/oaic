import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { SharedModule } from './../../../shared/shared.module';
import { FormsModule } from '@angular/forms';
import { NgxPrintModule } from 'ngx-print';

import { GlobalLedgerRoutingModule } from './global-ledger-routing.module';
import { GlobalComponent } from './global/global.component';


@NgModule({
  declarations: [
    GlobalComponent
  ],
  imports: [
    CommonModule,
    SharedModule,
    FormsModule,
    NgxPrintModule,
    GlobalLedgerRoutingModule
  ]
})
export class GlobalLedgerModule { }
