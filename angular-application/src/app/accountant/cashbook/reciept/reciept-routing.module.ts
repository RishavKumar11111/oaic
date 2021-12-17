import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { CashBookRecieptComponent } from './cash-book-reciept/cash-book-reciept.component';

const routes: Routes = [
  {
    path:'',
    component: CashBookRecieptComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class RecieptRoutingModule { }
