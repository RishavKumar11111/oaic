import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { SharedModule } from './../../../shared/shared.module';
import { FormsModule } from '@angular/forms';
import { NgxPrintModule } from 'ngx-print';

import { RePrintRoutingModule } from './re-print-routing.module';
import { RePrintComponent } from './re-print/re-print.component';
import { InvoiceModule } from 'src/app/report/invoice/invoice.module';


@NgModule({
  declarations: [
    RePrintComponent
  ],
  imports: [
    CommonModule,
    SharedModule,
    FormsModule,
    NgxPrintModule,
    RePrintRoutingModule,
    InvoiceModule,
  ]
})
export class RePrintModule { }
