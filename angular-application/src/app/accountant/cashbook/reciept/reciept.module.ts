import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { SharedModule } from './../../../shared/shared.module';
import { FormsModule } from '@angular/forms';
import { NgxPrintModule } from 'ngx-print';

import { RecieptRoutingModule } from './reciept-routing.module';
import { CashBookRecieptComponent } from './cash-book-reciept/cash-book-reciept.component';


@NgModule({
  declarations: [
    CashBookRecieptComponent
  ],
  imports: [
    CommonModule,
    SharedModule,
    FormsModule,
    NgxPrintModule,
    RecieptRoutingModule
  ]
})
export class RecieptModule { }
