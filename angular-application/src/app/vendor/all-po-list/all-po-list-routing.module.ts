import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { AllPoListComponent } from './all-po-list.component';

const routes: Routes = [
  {
    path: '',
    component: AllPoListComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class AllPoListRoutingModule { }
