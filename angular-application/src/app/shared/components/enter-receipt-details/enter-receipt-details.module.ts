import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { EnterReceiptDetailsComponent } from './enter-receipt-details/enter-receipt-details.component';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';



@NgModule({
  declarations: [
    EnterReceiptDetailsComponent
  ],
  imports: [
    CommonModule,
    FormsModule,
    ReactiveFormsModule
  ],
  exports: [
    EnterReceiptDetailsComponent
  ]
})
export class EnterReceiptDetailsModule { }
