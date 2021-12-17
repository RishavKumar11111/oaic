import { FormsModule } from '@angular/forms';
import { SharedModule } from 'src/app/shared/shared.module';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { WithheldAmountRoutingModule } from './withheld-amount-routing.module';
import { WithheldAmountComponent } from './withheld-amount.component';


@NgModule({
  declarations: [
    WithheldAmountComponent
  ],
  imports: [
    CommonModule,
    WithheldAmountRoutingModule,
    SharedModule,
    FormsModule
  ]
})
export class WithheldAmountModule { }
