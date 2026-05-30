"use strict";var me=Object.create;var D=Object.defineProperty;var ge=Object.getOwnPropertyDescriptor;var be=Object.getOwnPropertyNames;var $e=Object.getPrototypeOf,ye=Object.prototype.hasOwnProperty;var we=(e,t)=>{for(var r in t)D(e,r,{get:t[r],enumerable:!0})},Z=(e,t,r,n)=>{if(t&&typeof t=="object"||typeof t=="function")for(let l of be(t))!ye.call(e,l)&&l!==r&&D(e,l,{get:()=>t[l],enumerable:!(n=ge(t,l))||n.enumerable});return e};var z=(e,t,r)=>(r=e!=null?me($e(e)):{},Z(t||!e||!e.__esModule?D(r,"default",{value:e,enumerable:!0}):r,e)),ke=e=>Z(D({},"__esModule",{value:!0}),e);var _e={};we(_e,{default:()=>oe});module.exports=ke(_e);var U=require("react"),_=require("@raycast/api");var I=require("react"),d=require("@raycast/api");var c=z(require("react")),a=require("@raycast/api");var q=Object.prototype.hasOwnProperty;function L(e,t){var r,n;if(e===t)return!0;if(e&&t&&(r=e.constructor)===t.constructor){if(r===Date)return e.getTime()===t.getTime();if(r===RegExp)return e.toString()===t.toString();if(r===Array){if((n=e.length)===t.length)for(;n--&&L(e[n],t[n]););return n===-1}if(!r||typeof e=="object"){n=0;for(r in e)if(q.call(e,r)&&++n&&!q.call(t,r)||!(r in t)||!L(e[r],t[r]))return!1;return Object.keys(t).length===n}}return e!==e&&t!==t}var R=z(require("node:fs")),M=z(require("node:path"));var Q=require("react/jsx-runtime");function xe(e){let t=(0,c.useRef)(e),r=(0,c.useRef)(0);return L(e,t.current)||(t.current=e,r.current+=1),(0,c.useMemo)(()=>t.current,[r.current])}function y(e){let t=(0,c.useRef)(e);return t.current=e,t}function F(e,t){let r=e instanceof Error?e.message:String(e);return(0,a.showToast)({style:a.Toast.Style.Failure,title:t?.title??"Something went wrong",message:t?.message??r,primaryAction:t?.primaryAction??Y(e),secondaryAction:t?.primaryAction?Y(e):void 0})}var Y=e=>{let t=!0,r="[Extension Name]...",n="";try{let o=JSON.parse((0,R.readFileSync)((0,M.join)(a.environment.assetsPath,"..","package.json"),"utf8"));r=`[${o.title}]...`,n=`https://raycast.com/${o.owner||o.author}/${o.name}`,(!o.owner||o.access==="public")&&(t=!1)}catch{}let l=a.environment.isDevelopment||t,u=e instanceof Error?e?.stack||e?.message||"":String(e);return{title:l?"Copy Logs":"Report Error",onAction(o){o.hide(),l?a.Clipboard.copy(u):(0,a.open)(`https://github.com/raycast/extensions/issues/new?&labels=extension%2Cbug&template=extension_bug_report.yml&title=${encodeURIComponent(r)}&extension-url=${encodeURI(n)}&description=${encodeURIComponent(`#### Error:
\`\`\`
${u}
\`\`\`
`)}`)}}};function j(e,t,r){let n=(0,c.useRef)(0),[l,u]=(0,c.useState)({isLoading:!0}),o=y(e),f=y(r?.abortable),i=y(t||[]),v=y(r?.onError),S=y(r?.onData),G=y(r?.onWillExecute),K=y(r?.failureToastOptions),H=y(l.data),V=(0,c.useRef)(null),p=(0,c.useRef)({page:0}),W=(0,c.useRef)(!1),N=(0,c.useRef)(!0),J=(0,c.useRef)(50),E=(0,c.useCallback)(()=>(f.current&&(f.current.current?.abort(),f.current.current=new AbortController),++n.current),[f]),A=(0,c.useCallback)((...$)=>{let h=E();G.current?.($),u(s=>({...s,isLoading:!0}));let T=ve(o.current)(...$);function P(s){return s.name=="AbortError"||h===n.current&&(v.current?v.current(s):a.environment.launchType!==a.LaunchType.Background&&F(s,{title:"Failed to fetch latest data",primaryAction:{title:"Retry",onAction(C){C.hide(),V.current?.(...i.current||[])}},...K.current}),u({error:s,isLoading:!1})),s}return typeof T=="function"?(W.current=!0,T(p.current).then(({data:s,hasMore:C,cursor:he})=>(h===n.current&&(p.current&&(p.current.cursor=he,p.current.lastItem=s?.[s.length-1]),S.current&&S.current(s,p.current),C&&(J.current=s.length),N.current=C,u(pe=>p.current.page===0?{data:s,isLoading:!1}:{data:(pe.data||[])?.concat(s),isLoading:!1})),s),s=>(N.current=!1,P(s)))):(W.current=!1,T.then(s=>(h===n.current&&(S.current&&S.current(s),u({data:s,isLoading:!1})),s),P))},[S,v,i,o,u,V,G,p,K,E]);V.current=A;let O=(0,c.useCallback)(()=>{p.current={page:0};let $=i.current||[];return A(...$)},[A,i]),ce=(0,c.useCallback)(async($,h)=>{let T;try{if(h?.optimisticUpdate){E(),typeof h?.rollbackOnError!="function"&&h?.rollbackOnError!==!1&&(T=structuredClone(H.current?.value));let P=h.optimisticUpdate;u(s=>({...s,data:P(s.data)}))}return await $}catch(P){if(typeof h?.rollbackOnError=="function"){let s=h.rollbackOnError;u(C=>({...C,data:s(C.data)}))}else h?.optimisticUpdate&&h?.rollbackOnError!==!1&&u(s=>({...s,data:T}));throw P}finally{h?.shouldRevalidateAfter!==!1&&(a.environment.launchType===a.LaunchType.Background||a.environment.commandMode==="menu-bar"?await O():O())}},[O,H,u,E]),le=(0,c.useCallback)(()=>{p.current.page+=1;let $=i.current||[];A(...$)},[p,i,A]);(0,c.useEffect)(()=>{p.current={page:0},r?.execute!==!1?A(...t||[]):E()},[xe([t,r?.execute,A]),f,p]),(0,c.useEffect)(()=>()=>{E()},[E]);let ue=r?.execute!==!1?l.isLoading:!1,fe={...l,isLoading:ue},de=W.current?{pageSize:J.current,hasMore:N.current,onLoadMore:le}:void 0;return{...fe,revalidate:O,mutate:ce,pagination:de}}function ve(e){return e===Promise.all||e===Promise.race||e===Promise.resolve||e===Promise.reject?e.bind(Promise):e}function Se(e,t){let r=this[e];return r instanceof Date?`__raycast_cached_date__${r.toISOString()}`:Buffer.isBuffer(r)?`__raycast_cached_buffer__${r.toString("base64")}`:t}function Ee(e,t){return typeof t=="string"&&t.startsWith("__raycast_cached_date__")?new Date(t.replace("__raycast_cached_date__","")):typeof t=="string"&&t.startsWith("__raycast_cached_buffer__")?Buffer.from(t.replace("__raycast_cached_buffer__",""),"base64"):t}function X(e,t){let{data:r,isLoading:n,mutate:l}=j(async f=>{let i=await a.LocalStorage.getItem(f);return typeof i<"u"?JSON.parse(i,Ee):t},[e]);async function u(f){try{await l(a.LocalStorage.setItem(e,JSON.stringify(f,Se)),{optimisticUpdate(i){return i}})}catch(i){await F(i,{title:"Failed to set value in local storage"})}}async function o(){try{await l(a.LocalStorage.removeItem(e),{optimisticUpdate(){}})}catch(f){await F(f,{title:"Failed to remove value from local storage"})}}return{value:r,setValue:u,removeValue:o,isLoading:n}}var m=require("react/jsx-runtime"),Ae=({onSubmit:e})=>{let[t,r]=(0,I.useState)(""),[n,l]=(0,I.useState)("new"),{isLoading:u,value:o,removeValue:f}=X("test-string-history");return(0,I.useEffect)(()=>{ee[n]?r(ee[n]):r(o?.find(i=>i.id===n)?.value||"")},[n]),(0,m.jsxs)(d.Form,{isLoading:u,actions:(0,m.jsxs)(d.ActionPanel,{children:[(0,m.jsx)(d.Action.SubmitForm,{icon:d.Icon.Check,title:"Test Regex",onSubmit:e}),(0,m.jsx)(d.Action,{icon:d.Icon.ClearFormatting,title:"Clear Previous Test Strings",onAction:f,shortcut:{macOS:{modifiers:["cmd"],key:"backspace"},Windows:{modifiers:["ctrl"],key:"backspace"}}})]}),children:[(0,m.jsxs)(d.Form.Dropdown,{id:"source",title:"",defaultValue:"new",onChange:l,children:[(0,m.jsx)(d.Form.Dropdown.Item,{value:"new",title:"New Test String"}),(0,m.jsx)(d.Form.Dropdown.Item,{value:"lorem",title:"Lorem Ipsum"}),o&&(0,m.jsx)(d.Form.Dropdown.Section,{title:"Previous Test Strings",children:o.map(i=>(0,m.jsx)(d.Form.Dropdown.Item,{value:i.id,title:i.value},i.id))})]}),(0,m.jsx)(d.Form.TextArea,{id:"text",title:"",placeholder:"Enter your test string",value:t,onChange:r})]})},ee={lorem:"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla malesuada viverra elit, at placerat metus dictum at. Aliquam pretium, massa nec interdum hendrerit, libero ipsum rutrum nibh, iaculis fringilla magna ante sit amet quam. Donec imperdiet leo risus, et accumsan sem malesuada eu. Nunc suscipit urna magna, sit amet tempus lectus laoreet vitae. Fusce in dolor vitae lacus luctus ullamcorper. Maecenas faucibus fringilla feugiat. Phasellus purus mauris, molestie vel dolor eget, posuere iaculis mauris. Nunc blandit neque ut semper ultrices. Cras tempus mollis pharetra. Quisque euismod orci eget augue lobortis feugiat. Suspendisse at consequat eros."},te=Ae;var k=require("@raycast/api"),x=require("react");var re=require("@raycast/api"),ae=require("react/jsx-runtime"),Ce=()=>(0,ae.jsx)(re.List.Item.Detail,{markdown:Re}),Re=`
# Regular Expression Cheat Sheet

## Character Classes

\`.\`

any character except newline

\`\\w\\d\\s\`

word, digit, whitespace

\`\\W\\D\\S\`

not word, digit, whitespace

\`[abc]\`

any of a, b, or c

\`[^abc]\`

not a, b, or c

\`[a-g]\`

character between a & g

## Anchors

\`^abc$\`

start / end of the string

\`\\b\\B\`

word, not-word boundary

## Escaped characters

\`\\.\\*\\\\\`

escaped special characters

\`\\t\\n\\r\`

tab, linefeed, carriage return

## Groups & Lookaround

\`(abc)\`

capture group

\`\\1\`

backreference to group #1

\`(?:abc)\`

non-capturing group

\`(?=abc)\`

positive lookahead

\`(?!abc)\`

negative lookahead

## Quantifiers & Alternation

\`a*a+a?\`

0 or more, 1 or more, 0 or 1

\`a{5}a{2,}\`

exactly five, two or more

\`a{1,3}\`

between one & three

\`a+?a{2,}?\`

match as few as possible

\`ab|cd\`

match ab or cd

`,ne=Ce;var b=require("@raycast/api"),g=require("react/jsx-runtime"),Te=({onOptionsChange:e})=>(0,g.jsxs)(b.List.Dropdown,{tooltip:"Regex Options",defaultValue:"gm",onChange:e,children:[(0,g.jsx)(b.List.Dropdown.Item,{title:"No Modifiers",value:""}),(0,g.jsx)(b.List.Dropdown.Item,{title:"Global (/g)",value:"g"}),(0,g.jsx)(b.List.Dropdown.Item,{title:"Case-Insensitive (/i)",value:"i"}),(0,g.jsx)(b.List.Dropdown.Item,{title:"Multiline (/m)",value:"m"}),(0,g.jsx)(b.List.Dropdown.Item,{title:"Global, Case-Insensitive (/gi)",value:"gi"}),(0,g.jsx)(b.List.Dropdown.Item,{title:"Global, Multiline (/gm)",value:"gm"}),(0,g.jsx)(b.List.Dropdown.Item,{title:"Case-Insensitive, Multiline (/im)",value:"im"}),(0,g.jsx)(b.List.Dropdown.Item,{title:"All Modifiers (/gim)",value:"gim"})]}),se=Te;var w=require("react/jsx-runtime"),Pe=({testString:e})=>{let[t,r]=(0,x.useState)(""),[n,l]=(0,x.useState)(""),[u,o]=(0,x.useState)("gm"),f=(0,x.useCallback)(i=>{o(i)},[]);return(0,x.useEffect)(()=>{if(t===""){l(e);return}try{let i=e.replace(new RegExp(t,u),v=>`|${v}|`);l(i)}catch(i){console.log("regex error",i)}},[e,t,u]),(0,w.jsxs)(k.List,{isShowingDetail:!0,filtering:!1,searchBarPlaceholder:"([A-Z])\\w+",searchText:t,onSearchTextChange:r,searchBarAccessory:(0,w.jsx)(se,{onOptionsChange:f}),children:[(0,w.jsx)(k.List.Item,{icon:k.Icon.MagnifyingGlass,title:"Preview",detail:(0,w.jsx)(k.List.Item.Detail,{markdown:n})}),(0,w.jsx)(k.List.Item,{icon:k.Icon.QuestionMark,title:"Cheat Sheet",detail:(0,w.jsx)(ne,{})})]})},ie=Pe;var B=require("react/jsx-runtime");function oe(){let[e,t]=(0,U.useState)(""),[r,n]=(0,U.useState)(),{push:l}=(0,_.useNavigation)();j(async o=>{if(o==="new"){let f={id:Date.now().toString(),value:e},i=await _.LocalStorage.getItem("test-string-history");if(i){let v=JSON.parse(i),S=[f,...v].slice(0,5);await _.LocalStorage.setItem("test-string-history",JSON.stringify(S))}else await _.LocalStorage.setItem("test-string-history",JSON.stringify([f]))}},[r]);let u=(0,U.useCallback)(o=>{t(o.text),n(o.source),l((0,B.jsx)(ie,{testString:o.text}))},[]);return(0,B.jsx)(te,{onSubmit:u})}
