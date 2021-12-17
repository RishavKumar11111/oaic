import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { CalculateItemPriceComponent } from './calculate-item-price.component';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';



@NgModule({
  declarations: [
    CalculateItemPriceComponent
  ],
  imports: [
    CommonModule,
    FormsModule,
    ReactiveFormsModule
  ],
  exports: [
    CalculateItemPriceComponent
  ]
})
export class CalculateItemPriceModule { }
