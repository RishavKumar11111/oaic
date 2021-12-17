import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { InvoiceComponent } from './invoice.component';
import { SharedModule } from 'src/app/shared/shared.module';



@NgModule({
  declarations: [
    InvoiceComponent
  ],
  imports: [
    CommonModule,
    SharedModule
  ],
  exports: [
    InvoiceComponent
  ]
})
export class InvoiceModule { }
