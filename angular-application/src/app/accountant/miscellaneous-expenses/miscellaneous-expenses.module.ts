import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { MiscellaneousExpensesRoutingModule } from './miscellaneous-expenses-routing.module';
import { MiscellaneousExpensesComponent } from './miscellaneous-expenses/miscellaneous-expenses.component';
import { FormsModule } from '@angular/forms';


@NgModule({
  declarations: [
    MiscellaneousExpensesComponent
  ],
  imports: [
    CommonModule,
    MiscellaneousExpensesRoutingModule,
    FormsModule
  ]
})
export class MiscellaneousExpensesModule { }
