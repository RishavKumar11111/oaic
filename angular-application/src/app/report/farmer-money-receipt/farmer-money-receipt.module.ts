import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FarmerMoneyReceiptComponent } from './farmer-money-receipt.component';
import { SharedModule } from 'src/app/shared/shared.module';



@NgModule({
  declarations: [
    FarmerMoneyReceiptComponent
  ],
  imports: [
    CommonModule,
    SharedModule
  ],
  exports: [
    FarmerMoneyReceiptComponent
  ]
})
export class FarmerMoneyReceiptModule { }
