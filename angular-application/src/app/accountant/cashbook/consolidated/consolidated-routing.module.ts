import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { CashBookConsolidatedComponent } from './cash-book-consolidated/cash-book-consolidated.component';


const routes: Routes = [
  {
    path: '',
    component: CashBookConsolidatedComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ConsolidatedRoutingModule { }
