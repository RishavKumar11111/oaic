import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { InitiateComponent } from './initiate/initiate.component';

const routes: Routes = [
  {
    path: '',
    component: InitiateComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class InitiateRoutingModule { }
