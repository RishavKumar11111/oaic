import { trigger, transition, style, query, animateChild, animate, group } from "@angular/animations";

export const fadeAnimation =
  trigger('fadeAnimation', [

    transition('* => *', [
        style({ position: 'relative' }),
        query(':enter, :leave', [
          style({
            position: 'absolute',
            top: 0,
            left: 0,
            width: '100%'
          })
        ],),
        query(':enter', [
          style({ opacity: 0 })
        ]),
        query(':leave', animateChild(), { optional: true }),
        group([
          query(':leave', [
            animate('700ms ease', style({ opacity: 0 }))
          ], { optional: true }),
          query(':enter', [
            animate('900ms ease', style({ opacity: 1 }))
          ])
        ]),
        query(':enter', animateChild()),
      ]),

  ]);
  export const slideInAnimation =
    trigger('slideInAnimation', [
      transition('* => *', [
        style({ position: 'relative' }),
        query(':enter, :leave', [
          style({
            position: 'absolute',
            top: 0,
            left: 0,
            width: '100%'
          })
        ],),
        query(':enter', [
          style({ left: '-100%', opacity: 0 })
        ]),
        query(':leave', animateChild(), { optional: true }),
        group([
          query(':leave', [
            animate('700ms ease', style({ left: '100%', opacity: 0 }))
          ], { optional: true }),
          query(':enter', [
            animate('900ms ease', style({ left: '0%', opacity: 1 }))
          ])
        ]),
        query(':enter', animateChild()),
      ]),

    ]);