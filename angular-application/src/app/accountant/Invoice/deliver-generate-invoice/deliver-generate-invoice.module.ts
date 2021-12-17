import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { NgxPrintModule } from 'ngx-print';

import { DeliverGenerateInvoiceRoutingModule } from './deliver-generate-invoice-routing.module';
import { DeliverGenerateInvoiceComponent } from './deliver-generate-invoice/deliver-generate-invoice.component';
import { SharedModule } from 'src/app/shared/shared.module';
import { InvoiceModule } from 'src/app/report/invoice/invoice.module';
import { NormalCardModule } from 'src/app/shared/ui/normal-card/normal-card.module';
import { TableCardModule } from 'src/app/shared/ui/table-card/table-card.module';

@NgModule({
  declarations: [
    DeliverGenerateInvoiceComponent
  ],
  imports: [
    CommonModule,
    SharedModule,
    FormsModule,
    ReactiveFormsModule,
    NgxPrintModule,
    DeliverGenerateInvoiceRoutingModule,
    InvoiceModule,
    NormalCardModule,
    TableCardModule
  ]
})
export class DeliverGenerateInvoiceModule { }
