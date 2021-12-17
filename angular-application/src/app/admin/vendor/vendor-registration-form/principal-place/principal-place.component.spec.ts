import { ComponentFixture, TestBed } from '@angular/core/testing';

import { PrincipalPlaceComponent } from './principal-place.component';

describe('PrincipalPlaceComponent', () => {
  let component: PrincipalPlaceComponent;
  let fixture: ComponentFixture<PrincipalPlaceComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ PrincipalPlaceComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(PrincipalPlaceComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
