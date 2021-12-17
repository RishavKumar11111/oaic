import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ViewPermitDetailsComponent } from './view-permit-details.component';

describe('ViewPermitDetailsComponent', () => {
  let component: ViewPermitDetailsComponent;
  let fixture: ComponentFixture<ViewPermitDetailsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ ViewPermitDetailsComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(ViewPermitDetailsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
