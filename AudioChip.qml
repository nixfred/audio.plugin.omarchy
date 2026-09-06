import QtQuick
import "Model.js" as Model

// A glowing audio die. The body fills like RAM Pulse, spectrum bars carry
// the live level, and the inner mark switches for speakers, headphones, HDMI
// or a wireless sink. Aura, orbit rings and pins match CPU Pulse and Net Pulse
// so the chips read as siblings on the bar.
Item {
    id: root
    property string kind: 'speaker'   // 'speaker' | 'headphones' | 'hdmi' | 'bluetooth' | 'none'
    property real level: 0            // 0–1 output volume
    property real activity: 0         // 0–1 peak or traffic, drives bar motion
    property bool muted: false
    property bool animate: true
    property bool compact: false
    property color tint: "#43f2a1"
    property real phase: 0
    property real shownLevel: level
    implicitWidth: compact ? 28 : 160
    implicitHeight: compact ? 25 : 160
    Behavior on shownLevel { NumberAnimation { duration: 1200; easing.type: Easing.InOutCubic } }
    Behavior on tint { ColorAnimation { duration: 1100 } }
    NumberAnimation on phase { from: 0; to: 1; duration: 5800; loops: Animation.Infinite; running: root.animate }
    onPhaseChanged: canvas.requestPaint()
    onTintChanged: canvas.requestPaint()
    onShownLevelChanged: canvas.requestPaint()
    onKindChanged: canvas.requestPaint()
    onActivityChanged: canvas.requestPaint()
    onMutedChanged: canvas.requestPaint()
    onAnimateChanged: canvas.requestPaint()
    Canvas {
        id: canvas
        anchors.fill: parent
        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
        onPaint: {
            var c = getContext('2d'), w = width, h = height
            c.reset(); c.clearRect(0,0,w,h)
            var cx=w/2, cy=h/2, size=Math.min(w,h), body=size*(root.compact?0.58:0.47)
            if (size <= 0 || body <= 0) return
            var x=cx-body/2, y=cy-body/2, t=root.phase*Math.PI*2
            var lvl=Model.clamp(root.shownLevel,0,1)
            var act=Model.clamp(root.muted ? 0 : root.activity,0,1)
            var live=root.muted ? 0 : lvl
            var aura=c.createRadialGradient(cx,cy,body*0.1,cx,cy,size*0.5)
            aura.addColorStop(0,Qt.alpha(root.tint,0.30+0.25*live)); aura.addColorStop(0.6,Qt.alpha(root.tint,0.20+0.07*Math.sin(t))); aura.addColorStop(1,'transparent')
            c.fillStyle=aura; c.fillRect(0,0,w,h)
            if (!root.compact) {
                for(var ring=0;ring<3;ring++) {
                    c.beginPath(); c.strokeStyle=Qt.alpha(root.tint,0.11+ring*0.04); c.lineWidth=1
                    c.arc(cx,cy,body*(0.78+ring*0.12),0,Math.PI*2); c.stroke()
                    c.beginPath(); c.strokeStyle=Qt.alpha(root.tint,0.65); c.lineWidth=2
                    var ang=t*(1+act*2)*(ring%2===0?1:-1)+ring*2
                    c.arc(cx,cy,body*(0.78+ring*0.12),ang,ang+0.42);c.stroke()
                }
            }
            c.fillStyle='#0b141b'; c.strokeStyle=root.tint; c.lineWidth=root.compact?1.2:2
            c.fillRect(x,y,body,body)
            c.shadowColor=root.tint; c.shadowBlur=root.compact?5:12
            c.strokeRect(x,y,body,body); c.shadowBlur=0
            c.save();c.beginPath();c.rect(x+2,y+2,body-4,body-4);c.clip()
            c.strokeStyle=Qt.alpha(root.tint,0.18);c.lineWidth=0.8
            for(var row=1;row<4;row++){ c.beginPath();c.moveTo(x,y+body*row/4);c.lineTo(x+body,y+body*row/4);c.stroke() }
            var fillY=y+body*(1-live)
            var liquid=c.createLinearGradient(0,y,0,y+body)
            liquid.addColorStop(0,Qt.alpha(root.tint,0.65)); liquid.addColorStop(1,Qt.alpha(root.tint,0.16))
            c.beginPath();c.moveTo(x,y+body);c.lineTo(x,fillY)
            for(var px=0;px<=body;px+=2) c.lineTo(x+px,fillY+Math.sin(px/body*Math.PI*3+t)*(root.compact?1:3)*(0.4+0.6*act))
            c.lineTo(x+body,y+body);c.closePath();c.fillStyle=liquid;c.fill()
            var bars=root.compact?5:9, barW=body/(bars*2.4), base=y+body*0.92
            for(var i=0;i<bars;i++){
                var envelope=Math.sin(Math.PI*(i+1)/(bars+1))
                var wobble=root.animate?0.62+0.38*Math.abs(Math.sin(t*(1.4+act)+i*0.9)):1
                var bh=body*(root.compact?0.55:0.42)*live*envelope*wobble*(0.55+0.45*act)
                var bx=x+body*(i+0.5)/bars
                c.fillStyle=Qt.alpha(root.tint,0.35+0.55*live)
                c.fillRect(bx-barW/2,base-bh,barW,Math.max(root.compact?1:2,bh))
            }
            c.strokeStyle=root.tint;c.fillStyle=root.tint;c.lineWidth=root.compact?1.1:2
            if (root.kind === 'headphones') {
                c.beginPath();c.arc(cx,cy-body*0.04,body*0.22,Math.PI*1.12,Math.PI*1.88);c.stroke()
                var cupW=body*(root.compact?0.12:0.10), cupH=body*(root.compact?0.22:0.24)
                c.fillRect(cx-body*0.28,cy-body*0.04,cupW,cupH)
                c.fillRect(cx+body*0.28-cupW,cy-body*0.04,cupW,cupH)
            } else if (root.kind === 'hdmi') {
                var dw=body*0.46, dh=body*0.28, dx=cx-dw/2, dy=cy-body*0.22
                c.strokeRect(dx,dy,dw,dh)
                c.beginPath();c.moveTo(cx-body*0.06,dy+dh);c.lineTo(cx+body*0.06,dy+dh);c.lineTo(cx+body*0.10,dy+dh+body*0.08);c.lineTo(cx-body*0.10,dy+dh+body*0.08);c.closePath();c.fill()
            } else if (root.kind === 'none') {
                c.lineWidth=root.compact?1.2:2.5;c.setLineDash([body*0.08,body*0.08])
                c.beginPath();c.arc(cx,cy-body*0.08,body*0.22,0,Math.PI*2);c.stroke();c.setLineDash([])
            } else {
                // Speaker cone, with extra wireless arcs on a Bluetooth sink.
                var mx=cx-body*0.20, my=cy-body*(root.compact?0.22:0.26)
                var mw=body*0.14, mh=body*(root.compact?0.18:0.20)
                c.fillRect(mx,my,mw,mh)
                c.beginPath()
                c.moveTo(mx+mw,my)
                c.lineTo(cx+body*0.16,cy-body*(root.compact?0.32:0.36))
                c.lineTo(cx+body*0.16,cy-body*(root.compact?0.06:0.06))
                c.lineTo(mx+mw,my+mh)
                c.closePath();c.fill()
                var arcs=root.kind==='bluetooth'?4:3
                for(var a=1;a<=arcs;a++){
                    var lit=live*arcs>=a-0.5, pulse=(a===Math.min(arcs,Math.max(1,Math.ceil(live*arcs))))?0.65+0.35*Math.sin(t*2):1
                    c.beginPath();c.strokeStyle=Qt.alpha(root.tint,lit?0.9*pulse:0.16);c.lineWidth=(root.compact?1.1:2.4)*(lit?1:0.7)
                    c.arc(cx+body*0.16,cy-body*0.16,body*0.10*a,-0.78,0.78);c.stroke()
                }
            }
            if (root.muted || root.kind === 'none') {
                c.strokeStyle=Qt.alpha(root.tint,0.9);c.lineWidth=root.compact?1.4:2.6;c.lineCap='round'
                c.beginPath();c.moveTo(x+body*0.18,y+body*0.18);c.lineTo(x+body*0.82,y+body*0.82);c.stroke()
            }
            c.restore()
            c.strokeStyle=root.tint;c.lineWidth=root.compact?1:2
            for(var p=0;p<4;p++) {
                var q=body*(p+1)/5, len=body*0.17
                c.beginPath();c.moveTo(x+q,y-len);c.lineTo(x+q,y);c.moveTo(x+q,y+body);c.lineTo(x+q,y+body+len)
                c.moveTo(x-len,y+q);c.lineTo(x,y+q);c.moveTo(x+body,y+q);c.lineTo(x+body+len,y+q);c.stroke()
                if(!root.compact && !root.muted && root.kind !== 'none'){
                    var progress=((root.phase*(1+act*4))+p/4)%1
                    c.fillStyle=Qt.alpha(root.tint,1-progress*0.5)
                    c.beginPath();c.arc(x+q,y-len-body*0.3+progress*body*0.3,1.7,0,Math.PI*2);c.fill()
                    c.beginPath();c.arc(x+body+len+progress*body*0.3,y+q,1.7,0,Math.PI*2);c.fill()
                }
            }
        }
    }
}
