import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { MiscellaneousExpensesComponent } from './miscellaneous-expenses/miscellaneous-expenses.component';

const routes: Routes = [
  {
    path: '',
    component: MiscellaneousExpensesComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class MiscellaneousExpensesRoutingModule { }
